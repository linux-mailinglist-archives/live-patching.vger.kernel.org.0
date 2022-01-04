Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED97484402
	for <lists+live-patching@lfdr.de>; Tue,  4 Jan 2022 15:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbiADO7x (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 4 Jan 2022 09:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234533AbiADO7x (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 4 Jan 2022 09:59:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 531C3C061784;
        Tue,  4 Jan 2022 06:59:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB095B8160D;
        Tue,  4 Jan 2022 14:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F62C36AED;
        Tue,  4 Jan 2022 14:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641308390;
        bh=0YtB+fbCghSHxYyJ14GrAVcGcHtvp6iLQGuLPtMgyjw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R/qfnbgl6yOtWE+9DWR3GlTnJtJ8NDZUSWh7P7jdvOHBIYLJOCjyHUsuy/WGzUQSW
         Vz0tHfDRmZh2wmwB2m2DYgTC1VTYoP8fROISgc8jeN5LC5m6BeAm/Ye7NseckOi8rP
         GxdAEJ5j0uhUl/eVNHPT4aScSkfnJKIlPn3ba2o13CK4JYQhtrI75r7tjxrVCo6yCl
         rw0rstDmvc4d56JEAIB6g2ejKCaijKU2lqxmdLxsSOHp+ZN1l537KylCmfJoEZz1FP
         aqJoImxAG9D8KC995/tZrDSYKA8+BR7wmGBIVEUz5Qf6M9KL0c7T3h8RTikpzOJM6+
         rHcb1FcxWo6QQ==
Date:   Tue, 4 Jan 2022 14:59:45 +0000
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 03/10] arm64: Rename stackframe to unwind_state
Message-ID: <YdRg4YoQK1q2D18w@sirena.org.uk>
References: <0d0eb36f348fb5a6af6eb592c0525f6e94007328>
 <20220103165212.9303-1-madvenka@linux.microsoft.com>
 <20220103165212.9303-4-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="U1asr6fzYkExICKZ"
Content-Disposition: inline
In-Reply-To: <20220103165212.9303-4-madvenka@linux.microsoft.com>
X-Cookie: The horror... the horror!
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--U1asr6fzYkExICKZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 03, 2022 at 10:52:05AM -0600, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> Rename "struct stackframe" to "struct unwind_state" for consistency and
> better naming. Accordingly, rename variable/argument "frame" to "state".

Reviewed-by: Mark Brown <broonie@kernel.org>

--U1asr6fzYkExICKZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmHUYOAACgkQJNaLcl1U
h9C3Mwf+LOgVjCyi17Y+q629sBRAy3dgrQnMQaFZOWSyWyj+xPJAA+8JsHkFQxB9
6XYWlBXe41+4TUWTdGjbZQxvyKO5Pb0+5eG6+wWtPBBsD2CVSersJFEA6qwvNiYr
Tn4662TUCqZNaU/QHvk3WQZcmqBGtXj5J/m62ZtZ1bjHCffYoSa0tc7zEfG//bb6
C6e6UtcgF8HhKEk0bD4K0cPU63FPO8belLpd2j4xnR5RmT9cFPojQAOtwPv+0Xu/
y61Q7Bo0B5wcO7o6ZiP+yci/Uo8/v1xwQb86CoijYqGQBsVhpi5ceWtn75QP6Fce
Mdi7+rBMC+D7mZvF/6P3O6/F428mkA==
=K8ED
-----END PGP SIGNATURE-----

--U1asr6fzYkExICKZ--
