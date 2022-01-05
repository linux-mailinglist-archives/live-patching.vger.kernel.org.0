Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334334856EB
	for <lists+live-patching@lfdr.de>; Wed,  5 Jan 2022 17:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbiAEQ5M (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 5 Jan 2022 11:57:12 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49540 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiAEQ5M (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 5 Jan 2022 11:57:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5D325CE1E9E;
        Wed,  5 Jan 2022 16:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177FBC36AE0;
        Wed,  5 Jan 2022 16:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641401828;
        bh=9loWA3K7HOGjHq3wEdSkHMUmfK2cBnjZ0pReZsuqunA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qA/UBxs2CNyxJX3mHmyJ4+ew8lljfkX+6RCfcqQAPGd+aPJoRy/odoyd7jQw+t4AI
         05SL2VsSBR00EHA3PIAwgVEKoKb0F1syy/sHdPThLcP/XjedAku+CM6nsoucRQODdz
         fudRbvWcGy5pm380A6xSHpefcP8OKh58g6Zy8AxJhLsScxYH0LdU64zXNkejKIRq25
         GuU/sIiyEyhfezNPcY+m4S6Eo/YHEGQv3Eev7zyhy1UFUqJmzOzQeVTU4CeMAxf+tu
         67HFOtnzwHC/FYTosIYkKag19fAmaOoIf9BRYACnoTCMEAytPAESy/2FmOwC557MnC
         qybIQZuGzzFsA==
Date:   Wed, 5 Jan 2022 16:57:02 +0000
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 05/10] arm64: Copy unwind arguments to unwind_state
Message-ID: <YdXN3h2YASnjaIUu@sirena.org.uk>
References: <0d0eb36f348fb5a6af6eb592c0525f6e94007328>
 <20220103165212.9303-1-madvenka@linux.microsoft.com>
 <20220103165212.9303-6-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2jevHkgAmwttxavX"
Content-Disposition: inline
In-Reply-To: <20220103165212.9303-6-madvenka@linux.microsoft.com>
X-Cookie: Byte your tongue.
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--2jevHkgAmwttxavX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 03, 2022 at 10:52:07AM -0600, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> Copy the following arguments passed to arch_stack_walk() to unwind_state
> so that they can be passed to unwind functions via unwind_state rather
> than as separate arguments:

Reviwed-by: Mark Brown <broonie@kernel.org>

--2jevHkgAmwttxavX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmHVzd0ACgkQJNaLcl1U
h9Dw3Qf+PQx4AAcnO1Dx16tq/s6PUfSbxBuRmD7+leiPT6Jc1t2YYMQ+KBf2Qg57
d0MrR28bQ52OkYayM3ugZRjbBLQjVtSI2iRsEg2Dxf04cxPc1Do8ukC1rzKCRCji
NGz98VGQixRU0jHpanczdNqgn62/PwGrG6SVP+0UGYPRG/JZvI0raeWq9lPSatDJ
tFSexHnB/fTBsWytTbu44PS4D13Ct+5LWP/UwP9n3gPj4iKOF96K3IV6ecI6VI5+
vRUlWWlmGP5GZgoOjOA9NOAbVAG/L/7FM8b07JqK7qXzHNr/32rnOkmK1gtv9wBK
KBfl2oLvAIIty3Xg8mLb+2iR4CEgOw==
=4uvk
-----END PGP SIGNATURE-----

--2jevHkgAmwttxavX--
