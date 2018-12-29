with AUnit.Run;
with AUnit.Reporter.Text;
with Composite_Suite;

----------------
-- Pb_Harness --
----------------

procedure PB_Harness is

  procedure Run is new AUnit.Run.Test_Runner
    (Composite_Suite.Suite);
  Reporter : AUnit.Reporter.Text.Text_Reporter;

begin
  Run (Reporter);
end PB_Harness;
