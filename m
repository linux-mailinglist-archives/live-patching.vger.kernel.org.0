Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6493755D3
	for <lists+live-patching@lfdr.de>; Thu,  6 May 2021 16:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbhEFOp1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 May 2021 10:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234836AbhEFOp1 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 May 2021 10:45:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F86B6103E;
        Thu,  6 May 2021 14:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620312268;
        bh=BOhOb6YgchE5ciMqLJmE7uRp8FW6NeGqAmUnITHfSVU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hvDyxTYYz+7gnw5cNYYNCDXxdLfrZECQ3xI/3yWIQ3URVZNyowehM36n2Juet/7AB
         WuY+G79hTYxn6YL45OCZuVoieyqD60yM46C4qcTJJR2r1l58pHhr++zBIPq5DhbudN
         zeLG3Uaeqhe3qtTcmfIuuITVrZFPG93O9TdvDjevkth3BBpUyX18VciivkyJXSyl/7
         5aQ5GI+V+6A4WmJfdJzFRtFjqDPx32uZoCJlaNxkdgFnJd2PuicV8miLFmyl4tqbVm
         bd1p4T8uEMXTRa/EpHhTcz6wx4WYyC2mDLOQHRFBYifvpM027W7e7NYZAIg4aPt0Az
         aBHviYEG6l7qQ==
Date:   Thu, 6 May 2021 15:43:52 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     jpoimboe@redhat.com, mark.rutland@arm.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 4/4] arm64: Handle funtion graph tracer better in
 the unwinder
Message-ID: <20210506144352.GF4642@sirena.org.uk>
References: <65cf4dfbc439b010b50a0c46ec500432acde86d6>
 <20210503173615.21576-1-madvenka@linux.microsoft.com>
 <20210503173615.21576-5-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="A9z/3b/E4MkkD+7G"
Content-Disposition: inline
In-Reply-To: <20210503173615.21576-5-madvenka@linux.microsoft.com>
X-Cookie: If it ain't baroque, don't phiques it.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--A9z/3b/E4MkkD+7G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 03, 2021 at 12:36:15PM -0500, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> The Function Graph Tracer modifies the return address of a traced function
> to a return trampoline (return_to_handler()) to gather tracing data on
> function return. When the unwinder encounters return_to_handler(), it cal=
ls
> ftrace_graph_get_ret_stack() to lookup the original return address in the
> return address stack.

This makes sense to me, I'll need to re-review properly with the changes
earlier on in the series but should be fine.

--A9z/3b/E4MkkD+7G
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCUAKcACgkQJNaLcl1U
h9AW0gf/UurypPhoAeS5tOMAkEizbXPWkIR/0u9nPaBTkZHxtXZw07LAQrvIQ/wC
Q2UqJ3qIzHtM1KGaSWU+VOS2GYMY7WGmlhr6JNCmIk3LUuSoFxtlUYjwDoYWdKB+
UL7DhFiXJHHj6UfEquGtXpQ8WE9rl5s7c0MIxhbRmvXQVi12PLHobB0ksvZpGIkG
tcceN55GrlF6fTByLeQQwstNiD35/5dByUW0Swg3zXeYalbqd3GIlCv63K69IvFG
vCw4PoDBO6KCkped6KVPH9Mu7Ddf/8v8ZSOYVVTAVlRC+YNqpVDk942WbQsa7rBC
p8/D0psgllhFHPKxnwfUli1sECzxVw==
=zBTy
-----END PGP SIGNATURE-----

--A9z/3b/E4MkkD+7G--
