import { describe, expect, it, beforeEach } from "vitest";
import { Cl } from "@stacks/transactions";

const accounts = simnet.getAccounts();
const deployer = accounts.get("deployer")!;
const wallet1 = accounts.get("wallet_1")!;
const wallet2 = accounts.get("wallet_2")!;

const contractName = "community_waste";

describe("Community Waste Collection Contract Tests", () => {
  
  describe("Initialization Tests", () => {
    it("ensures simnet is well initialised", () => {
      expect(simnet.blockHeight).toBeDefined();
    });

    it("should return correct token name", () => {
      const { result } = simnet.callReadOnlyFn(contractName, "get-name", [], deployer);
      expect(result).toBeOk(Cl.stringAscii("SUSTAIN Token"));
    });

    it("should return correct token symbol", () => {
      const { result } = simnet.callReadOnlyFn(contractName, "get-symbol", [], deployer);
      expect(result).toBeOk(Cl.stringAscii("SUSTAIN"));
    });

    it("should return correct token decimals", () => {
      const { result } = simnet.callReadOnlyFn(contractName, "get-decimals", [], deployer);
      expect(result).toBeOk(Cl.uint(6));
    });

    it("should return initial total supply of zero", () => {
      const { result } = simnet.callReadOnlyFn(contractName, "get-total-supply", [], deployer);
      expect(result).toBeOk(Cl.uint(0));
    });

    it("should return initial total waste collected as zero", () => {
      const { result } = simnet.callReadOnlyFn(contractName, "get-total-waste-collected", [], deployer);
      expect(result).toBeOk(Cl.uint(0));
    });

    it("should return initial total STX received as zero", () => {
      const { result } = simnet.callReadOnlyFn(contractName, "get-total-stx-received", [], deployer);
      expect(result).toBeOk(Cl.uint(0));
    });

    it("should return deployer as contract owner", () => {
      const { result } = simnet.callReadOnlyFn(contractName, "get-contract-owner", [], deployer);
      expect(result).toStrictEqual(Cl.principal(deployer));
    });
  });

  describe("Household Registration Tests", () => {
    it("should allow a new household to register", () => {
      const { result } = simnet.callPublicFn(contractName, "register-household", [], wallet1);
      expect(result).toBeOk(Cl.bool(true));
    });

    it("should fail when household tries to register twice", () => {
      simnet.callPublicFn(contractName, "register-household", [], wallet1);
      const { result } = simnet.callPublicFn(contractName, "register-household", [], wallet1);
      expect(result).toBeErr(Cl.uint(409));
    });

    it("should return household info after registration", () => {
      simnet.callPublicFn(contractName, "register-household", [], wallet1);
      const { result } = simnet.callReadOnlyFn(contractName, "get-household-info", [Cl.principal(wallet1)], deployer);
      expect(result).toBeOk(Cl.tuple({
        registered: Cl.bool(true),
        "waste-count": Cl.uint(0),
        "paid-stx": Cl.uint(0)
      }));
    });

    it("should return error for unregistered household info", () => {
      const { result } = simnet.callReadOnlyFn(contractName, "get-household-info", [Cl.principal(wallet2)], deployer);
      expect(result).toBeErr(Cl.uint(404));
    });
  });

  describe("Report and Pay Tests", () => {
    it("should fail if household is not registered", () => {
      const { result } = simnet.callPublicFn(
        contractName, 
        "report-and-pay", 
        [Cl.uint(10), Cl.uint(1000)], 
        wallet1
      );
      expect(result).toBeErr(Cl.uint(401));
    });

    it("should fail with zero waste amount", () => {
      simnet.callPublicFn(contractName, "register-household", [], wallet1);
      const { result } = simnet.callPublicFn(
        contractName, 
        "report-and-pay", 
        [Cl.uint(0), Cl.uint(1000)], 
        wallet1
      );
      expect(result).toBeErr(Cl.uint(103));
    });

    it("should fail with zero fee per kg", () => {
      simnet.callPublicFn(contractName, "register-household", [], wallet1);
      const { result } = simnet.callPublicFn(
        contractName, 
        "report-and-pay", 
        [Cl.uint(10), Cl.uint(0)], 
        wallet1
      );
      expect(result).toBeErr(Cl.uint(103));
    });

    it("should successfully report waste and pay", () => {
      simnet.callPublicFn(contractName, "register-household", [], wallet1);
      const wasteKg = 10;
      const feePerKg = 1000;
      const expectedFee = wasteKg * feePerKg;
      
      const { result } = simnet.callPublicFn(
        contractName, 
        "report-and-pay", 
        [Cl.uint(wasteKg), Cl.uint(feePerKg)], 
        wallet1
      );
      expect(result).toBeOk(Cl.uint(expectedFee));
    });

    it("should update household waste count after reporting", () => {
      simnet.callPublicFn(contractName, "register-household", [], wallet1);
      const wasteKg = 15;
      
      simnet.callPublicFn(
        contractName, 
        "report-and-pay", 
        [Cl.uint(wasteKg), Cl.uint(1000)], 
        wallet1
      );
      
      const { result } = simnet.callReadOnlyFn(contractName, "get-household-info", [Cl.principal(wallet1)], deployer);
      expect(result).toBeOk(Cl.tuple({
        registered: Cl.bool(true),
        "waste-count": Cl.uint(wasteKg),
        "paid-stx": Cl.uint(wasteKg * 1000)
      }));
    });

    it("should update total waste collected", () => {
      simnet.callPublicFn(contractName, "register-household", [], wallet1);
      simnet.callPublicFn(contractName, "report-and-pay", [Cl.uint(20), Cl.uint(1000)], wallet1);
      
      const { result } = simnet.callReadOnlyFn(contractName, "get-total-waste-collected", [], deployer);
      expect(result).toBeOk(Cl.uint(20));
    });

    it("should mint SUSTAIN tokens as rewards", () => {
      simnet.callPublicFn(contractName, "register-household", [], wallet1);
      const wasteKg = 10;
      const expectedTokens = wasteKg * 10;
      
      simnet.callPublicFn(contractName, "report-and-pay", [Cl.uint(wasteKg), Cl.uint(1000)], wallet1);
      
      const { result } = simnet.callReadOnlyFn(contractName, "get-balance", [Cl.principal(wallet1)], deployer);
      expect(result).toBeOk(Cl.uint(expectedTokens));
    });

    it("should accumulate waste counts for multiple reports", () => {
      simnet.callPublicFn(contractName, "register-household", [], wallet1);
      
      simnet.callPublicFn(contractName, "report-and-pay", [Cl.uint(10), Cl.uint(1000)], wallet1);
      simnet.callPublicFn(contractName, "report-and-pay", [Cl.uint(15), Cl.uint(1000)], wallet1);
      
      const { result } = simnet.callReadOnlyFn(contractName, "get-total-waste-collected", [], deployer);
      expect(result).toBeOk(Cl.uint(25));
    });
  });

  describe("Token Transfer Tests", () => {
    it("should allow token owner to transfer tokens", () => {
      simnet.callPublicFn(contractName, "register-household", [], wallet1);
      simnet.callPublicFn(contractName, "report-and-pay", [Cl.uint(10), Cl.uint(1000)], wallet1);
      
      const { result } = simnet.callPublicFn(
        contractName, 
        "transfer", 
        [Cl.uint(50), Cl.principal(wallet1), Cl.principal(wallet2), Cl.none()], 
        wallet1
      );
      expect(result).toBeOk(Cl.bool(true));
    });

    it("should fail transfer with insufficient balance", () => {
      simnet.callPublicFn(contractName, "register-household", [], wallet1);
      simnet.callPublicFn(contractName, "report-and-pay", [Cl.uint(10), Cl.uint(1000)], wallet1);
      
      const { result } = simnet.callPublicFn(
        contractName, 
        "transfer", 
        [Cl.uint(1000), Cl.principal(wallet1), Cl.principal(wallet2), Cl.none()], 
        wallet1
      );
      expect(result).toBeErr(Cl.uint(102));
    });

    it("should fail transfer with zero amount", () => {
      const { result } = simnet.callPublicFn(
        contractName, 
        "transfer", 
        [Cl.uint(0), Cl.principal(wallet1), Cl.principal(wallet2), Cl.none()], 
        wallet1
      );
      expect(result).toBeErr(Cl.uint(103));
    });

    it("should fail transfer if not token owner", () => {
      simnet.callPublicFn(contractName, "register-household", [], wallet1);
      simnet.callPublicFn(contractName, "report-and-pay", [Cl.uint(10), Cl.uint(1000)], wallet1);
      
      const { result } = simnet.callPublicFn(
        contractName, 
        "transfer", 
        [Cl.uint(50), Cl.principal(wallet1), Cl.principal(wallet2), Cl.none()], 
        wallet2
      );
      expect(result).toBeErr(Cl.uint(101));
    });

    it("should update balances correctly after transfer", () => {
      simnet.callPublicFn(contractName, "register-household", [], wallet1);
      simnet.callPublicFn(contractName, "report-and-pay", [Cl.uint(10), Cl.uint(1000)], wallet1);
      
      simnet.callPublicFn(
        contractName, 
        "transfer", 
        [Cl.uint(30), Cl.principal(wallet1), Cl.principal(wallet2), Cl.none()], 
        wallet1
      );
      
      const balance1 = simnet.callReadOnlyFn(contractName, "get-balance", [Cl.principal(wallet1)], deployer);
      const balance2 = simnet.callReadOnlyFn(contractName, "get-balance", [Cl.principal(wallet2)], deployer);
      
      expect(balance1.result).toBeOk(Cl.uint(70));
      expect(balance2.result).toBeOk(Cl.uint(30));
    });
  });

  describe("Admin Withdraw Tests", () => {
    it("should fail withdraw if not contract owner", () => {
      const { result } = simnet.callPublicFn(contractName, "withdraw", [Cl.uint(1000)], wallet1);
      expect(result).toBeErr(Cl.uint(100));
    });

    it("should fail withdraw with zero amount", () => {
      const { result } = simnet.callPublicFn(contractName, "withdraw", [Cl.uint(0)], deployer);
      expect(result).toBeErr(Cl.uint(103));
    });

    it("should fail withdraw with insufficient contract balance", () => {
      const { result } = simnet.callPublicFn(contractName, "withdraw", [Cl.uint(1000000)], deployer);
      expect(result).toBeErr(Cl.uint(404));
    });
  });
});
