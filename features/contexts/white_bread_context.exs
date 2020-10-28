defmodule WhiteBreadContext do
  use WhiteBread.Context
  use Hound.Helpers

  feature_starting_state fn  ->
    Application.ensure_all_started(:hound)
    %{}
  end

  scenario_starting_state fn _state ->
    Hound.start_session
    %{}
  end

  # scenario_finalize fn _status, _state -> 
  #   # Hound.end_session
  #   nil
  # end

  given_ ~r/^that Account Manager is on a browser$/, fn state ->
    navigate_to "/session/new"
    {:ok, state}
  end

  when_ ~r/^the root path is accessed$/, fn _state ->
    {:ok, _state}
  end

  then_ ~r/^the home page is displayed with a Sign In form with heading Sign Into Account$/, fn _state ->
    {:ok, _state}
  end 

  and_ ~r/^with fields Email Address,Password,a Sign In button$/, fn _state ->
    {:ok, _state}
  end

  and_ ~r/^a link to Forgot Password? and a button Register$/, fn _state ->
    {:ok, _state}
  end
  
    # - Account Manager Signs In Successfully --> undefined step: that Account Manager accesses the "Sign In" form  implement with
  
  # given_ ~r/^that Account Manager accesses the "(?<argument_one>[^"]+)" form $/,
  # fn state, %{argument_one: _argument_one} ->
  #   {:ok, state}
  # end
  
  #   # - Account Manager Unsuccessfully Signs In  --> undefined step: that Account Manager accesses the "Sign In" form implement with
  
  # given_ ~r/^that Account Manager accesses the "(?<argument_one>[^"]+)" form$/,
  # fn state, %{argument_one: _argument_one} ->
  #   {:ok, state}
  # end

  scenario_finalize fn _status, _state -> 
    # Hound.end_session
    nil
  end
  
end
