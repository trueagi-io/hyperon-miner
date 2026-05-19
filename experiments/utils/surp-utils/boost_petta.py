from scipy import stats


def boost_math_cdf(alpha, beta, x):
    """
    Computes the CDF of a Beta distribution using scipy.stats,
    equivalent to boost::math::cdf(alpha, beta, min(1.0, x))

    Args:
        alpha (float): Alpha parameter
        beta (float): Beta parameter
        x (float): Input value

    Returns:
        float: The CDF result
    """
    try:
        # Clamp x to [0, 1]
        x_clamped = min(1.0, float(x))

        # Compute CDF
        return float(stats.beta.cdf(x_clamped, float(alpha), float(beta)))

    except ImportError:
        print("scipy not available. Install using: pip install scipy")
        return 0.0

    except Exception as e:
        print(f"Error computing beta CDF: {e}")
        return 0.0
