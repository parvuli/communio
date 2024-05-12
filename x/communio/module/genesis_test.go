package communio_test

import (
	"testing"

	keepertest "github.com/parvuli/communio/testutil/keeper"
	"github.com/parvuli/communio/testutil/nullify"
	communio "github.com/parvuli/communio/x/communio/module"
	"github.com/parvuli/communio/x/communio/types"
	"github.com/stretchr/testify/require"
)

func TestGenesis(t *testing.T) {
	genesisState := types.GenesisState{
		Params: types.DefaultParams(),

		// this line is used by starport scaffolding # genesis/test/state
	}

	k, ctx := keepertest.CommunioKeeper(t)
	communio.InitGenesis(ctx, k, genesisState)
	got := communio.ExportGenesis(ctx, k)
	require.NotNil(t, got)

	nullify.Fill(&genesisState)
	nullify.Fill(got)

	// this line is used by starport scaffolding # genesis/test/assert
}
