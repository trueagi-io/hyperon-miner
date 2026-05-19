from hyperon import *
from hyperon.ext import register_atoms
from hyperon.atoms import ExpressionAtom, E, GroundedAtom, OperationAtom, ValueAtom, NoReduceError, AtomType, MatchableObject, VariableAtom, \
    G, S, V, Atoms, get_string_value, GroundedObject, SymbolAtom

def boost_math_cdf(metta, alpha, beta, x):
    """
    Implementation using Python's scipy.stats for beta distribution CDF
    Equivalent to boost::math::cdf(alpha, beta, std::min(1.0, x))
    
    Args:
        metta: MeTTa instance
        alpha: Alpha parameter for beta distribution
        beta: Beta parameter for beta distribution  
        x: Input value (will be clamped to max 1.0)
    
    Returns:
        ValueAtom containing the CDF result
    """
    try:
        from scipy import stats
        
        # Extract numeric values from MeTTa atoms
        alpha_val = float(str(alpha).replace("#", ""))
        beta_val = float(str(beta).replace("#", ""))
        x_val = float(str(x).replace("#", ""))
        
        # Apply the std::min(1.0, x) constraint
        x_clamped = min(1.0, x_val)
        
        # Use scipy's beta distribution CDF (equivalent to boost::math::cdf for beta distribution)
        result = stats.beta.cdf(x_clamped, alpha_val, beta_val)
        result_float = float(result)
        # Convert result back to MeTTa atom
        return metta.parse_all(str(result_float))  # Using f-string for formatting])
        
    except ImportError:
        print("scipy not available, please install scipy: pip install scipy")
        return metta.parse_all([0.0])
    except Exception as e:
        print(f"Error in boost_math_cdf: {e}")
        return metta.parse_all([0.0])

@register_atoms(pass_metta=True)
def boost_math_cdf_reg(metta: MeTTa):
    """
    Register the boost math CDF function for use in MeTTa
    
    Returns:
        Dictionary mapping the function name to the OperationAtom
    """
    # Define the operation atom with its parameters and function
    boostCDF = OperationAtom('boost-math-cdf', 
                            lambda a, b, c: boost_math_cdf(metta, a, b, c),
                            ['Number', 'Number', 'Number', 'Number'], 
                            unwrap=False)
    
    return {
        r"boost-math-cdf": boostCDF
    }