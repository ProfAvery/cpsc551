# See <https://stackoverflow.com/questions/12539575/how-to-get-rid-of-rubys-warning-already-initialized-constant>

def suppress_warnings
  previous_VERBOSE, $VERBOSE = $VERBOSE, nil
  begin
    yield
  ensure
    $VERBOSE = previous_VERBOSE
  end
end

