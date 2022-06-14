Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD8354B808
	for <lists+live-patching@lfdr.de>; Tue, 14 Jun 2022 19:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbiFNRtP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Jun 2022 13:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345036AbiFNRtA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Jun 2022 13:49:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDCC33EBD;
        Tue, 14 Jun 2022 10:48:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82E8361739;
        Tue, 14 Jun 2022 17:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A771C3411B;
        Tue, 14 Jun 2022 17:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655228937;
        bh=vUYdTKApG+IF7N1DaWT1vcsrpTkET3iDbHsO6KbdhNw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wh402vLRYq+8GOactlzS9STTwqd0gX7VbxRuuEW6bHHjjq/dFyjm+d1e5UJ9pD1GA
         D2dfufwV8LtXWm+RIATYcNGcXJl/1f1rMxwHUiVYvKF0/wP1rzjm8AEeDhvwMygyGF
         w0NnIjCSVmwTj9Z2RLzviaaI1NHOif20LfQjzweP9Cy3SzirfBFfalOpu6aGhwkrmu
         P1RoGshq94208ktuvJBBx0/lZwHbcUd/9hFIL8pdmV7i/z6lRle8sIfeeqzClY8tnt
         MTF1aozF9Kos60JLnPb2g4JFJ0sJhyF4bHMnjSP8e9Ic9z7c5oakZi2FC4Te0JyBox
         oMXlVfmSk0tiA==
Date:   Tue, 14 Jun 2022 18:48:52 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v14 0/7] arm64: Reorganize the unwinder and implement
 stack trace reliability checks
Message-ID: <YqjKBF1dNKbTZrpY@sirena.org.uk>
References: <f460a35f88195413bcf7305e5083480aab3ca858>
 <20220413140528.3815-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2UWSi2k1RSFJ6caK"
Content-Disposition: inline
In-Reply-To: <20220413140528.3815-1-madvenka@linux.microsoft.com>
X-Cookie: DYSLEXICS OF THE WORLD, UNTIE!
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--2UWSi2k1RSFJ6caK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 13, 2022 at 09:05:21AM -0500, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> I have rebased this patch series on top of this branch:
>=20
> 	arm64/stacktrace/cleanups
>=20
> in Mark Rutland's fork of Linux. The branch contains a set of patches
> from Mark and me for reliable stack trace.

Do you have any plans to resend this based on v5.19-rcN?  I know you
were waiting for some more review feedback but everyone's review queues
will most likely have been flushed with the new release so it'll need a
resend.  I was half thinking about some related stuff so I went to apply
these but saw there's some small conflicts.

--2UWSi2k1RSFJ6caK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKoygMACgkQJNaLcl1U
h9DmsAf/YSmG2GfXSOpR16Oa1Hf/rrIlt5s62VLXhQcAdrfKtudpeISNVcncRJb6
6KBwLCxjj2XIw2o2TVEDqg6U6foDtenQitTzwDRJHC8YIu1fcxrOa9XUm+xmcpDv
3GtFq4S7E7oB2c5RhH0Xo/QM7IpJeIW8a6kYXO2Rqe54O3yRWJ7u3b2zmImfMmIc
pAQBbVTzZbmjYo8JnY90QD55BwO/v0OVs+NH4rj+bIEVa4dMLz98HI2gPeZoQYx5
R7l6ciD5tfN611S8hde3OmrObt4lXCWhqg6fBJGv7y9iVBQ2lyrfXdJZVC8xmDZ3
WgJghzObuld+OmjXU4PQxMt9AHaC6g==
=h07b
-----END PGP SIGNATURE-----

--2UWSi2k1RSFJ6caK--
