Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52ECB4A7833
	for <lists+live-patching@lfdr.de>; Wed,  2 Feb 2022 19:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239848AbiBBSrD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 2 Feb 2022 13:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346751AbiBBSrD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 2 Feb 2022 13:47:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BEDC06173B;
        Wed,  2 Feb 2022 10:47:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7494361924;
        Wed,  2 Feb 2022 18:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6679FC004E1;
        Wed,  2 Feb 2022 18:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643827621;
        bh=mBEDkji8JCmpzgtRJ5DMy3ZN8wH4LrWa0MpCxfoCfXE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J+KrxYLQSUe0x+kG6UILvvDSncCJDWkO3sFXCKBveYaqtaKXNWGAhZaQaZq9HJRKY
         7dYljhXz2CtXXA0onqZI4o3qNd9XCx3beakUgmNHS7HWSYJkdmvHHQ1fE2yhPZu5Y+
         J9KtCRti8rIH2ksrgjuMUqEQS46WNxZVBFwxir1Rzip8zMcK9oUF2kgj8zdkmv+RQm
         q9kEKkS4jot6gXxsIZ3sdrQARzfIVUxXxRjUj4g8ZUDLfWCnWHVhixtm6EADB/GgEb
         0y0h+doNRhPH5wj/C11uQWvWlVPZRtaSfh5OuFnNhn/t+Zi94Us787VV7KFXVo/AA3
         oqkuHl+pvTKFQ==
Date:   Wed, 2 Feb 2022 18:46:56 +0000
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 06/11] arm64: Use stack_trace_consume_fn and rename
 args to unwind()
Message-ID: <YfrRoA63/UOXTJc0@sirena.org.uk>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
 <20220117145608.6781-7-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="njCht9jCwRKJ+dPv"
Content-Disposition: inline
In-Reply-To: <20220117145608.6781-7-madvenka@linux.microsoft.com>
X-Cookie: Quack!
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--njCht9jCwRKJ+dPv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 17, 2022 at 08:56:03AM -0600, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> Rename the arguments to unwind() for better consistency. Also, use the
> typedef stack_trace_consume_fn for the consume_entry function as it is
> already defined in linux/stacktrace.h.

Consistency with...?  But otherwise:

Reviewed-by: Mark Brown <broonie@kernel.org>

--njCht9jCwRKJ+dPv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmH60Z8ACgkQJNaLcl1U
h9CRVAf/e7AUjvtw9CpStQl88F9xMn8uBVroK2T5X0IIX6ev12GrMUMGHNt9qioZ
VdPU8CbLEzkj0NTQNGiQTQpbu6UmhVqpwyCMgOmE9/Bf75xeb2p72XY1U03kDa36
ZxPVma74wWOyyo26AnMDYoTrA3li0NQdFVXS2y9MUQeiRKc6xhloS4bj24TluSbr
5S9ln91rxiXG8IxpmwK/XXSVT//SrNcPMiuMiHYefcKwZtcadH/iBNmXW8qj0MQY
TwAlOnRItDBGA9lfLNBqGqKM77wMDHzCU9WIxyz5/vq09+B+gHTvSEp5LTTcpmO0
mcjCjwzOfs2hs+Hl9uzmaYj93BDajg==
=E+Wb
-----END PGP SIGNATURE-----

--njCht9jCwRKJ+dPv--
