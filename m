Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0CCF4D2E65
	for <lists+live-patching@lfdr.de>; Wed,  9 Mar 2022 12:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiCILsp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 9 Mar 2022 06:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbiCILso (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 9 Mar 2022 06:48:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256F9710E3;
        Wed,  9 Mar 2022 03:47:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C04AA61882;
        Wed,  9 Mar 2022 11:47:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405E6C340E8;
        Wed,  9 Mar 2022 11:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646826465;
        bh=+QA/FxGruRPfGsGWICz2UjyGiib5mePYmSUey22VoFg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DjiDDldUNNlnovKQ0JBaKVcuvn/dbfSjkRQkbCon5BAEFHaDkySjAYE2z+U7bla3G
         wWR/Umyl72MgH7tmmkUe466DMUJIFYNoFfy07My64dQoDPg1ZM/TNs34ggE2ZIUfpy
         Lnc8BE38NSlbtEpHJ+mul9H+B/aDXnQDlDoDT18aqSyaIU2FZGFNrrFbKoPDNFiJGS
         VMDpHT5YNJ9Du77/e9jqTuhl9qNu7jKrRNTDnltslkNYHL7hxsQIVbJAr/PRD14Ii2
         sf+Vc8uS12V1qWI5iIS0kRBXZEgzKuaYVEzdJx5gMHOvRTnfbACHuYHJAMAVgG64Sk
         1lUmhK3LaPBjg==
Date:   Wed, 9 Mar 2022 11:47:38 +0000
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 06/11] arm64: Use stack_trace_consume_fn and rename
 args to unwind()
Message-ID: <YiiT2lFuxc3ob+Zq@sirena.org.uk>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
 <20220117145608.6781-7-madvenka@linux.microsoft.com>
 <YgutJKqYe8ss8LLd@FVFF77S0Q05N>
 <845e4589-97d9-5371-3a0e-f6e05919f32d@linux.microsoft.com>
 <YiY6hecX0pVWowQ7@sirena.org.uk>
 <c494fa10-e973-c137-b637-66bde327611c@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fR2gx6UElM3+rVbt"
Content-Disposition: inline
In-Reply-To: <c494fa10-e973-c137-b637-66bde327611c@linux.microsoft.com>
X-Cookie: You will inherit millions of dollars.
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--fR2gx6UElM3+rVbt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 08, 2022 at 04:00:35PM -0600, Madhavan T. Venkataraman wrote:

> It is just that patch 11 that defines "select
> HAVE_RELIABLE_STACKTRACE" did not receive any comments from you
> (unless I missed a comment that came from you. That is entirely
> possible. If I missed it, my bad). Since you suggested that change, I
> just wanted to make sure that that patch looks OK to you.

I think that's more a question for the livepatch people to be honest -
it's not entirely a technical one, there's a bunch of confidence level
stuff going on.  For example there was some suggestion that people might
insist on having objtool support, though there's also substantial
pushback on making objtool a requirement for anything from other
quarters.  I was hoping that posting that patch would provoke some
discussion about what exactly is needed but that's not happened thus
far.

--fR2gx6UElM3+rVbt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIok9kACgkQJNaLcl1U
h9Atswf/aYL+WGkgkI963GJMyK23dK7OKYHwJjpAKq7WTCiRO8kPKRIENSCe4khl
qf1PIUDbuaEWsacF/ovb7WGNFEqtuNuGwJCdsEeVjHPya0+FxLkQZ2qI/gF0dZgB
l06fXYg29pg5oXdYWxaJHERjgPQbZxm7FnLkNd49g2KgeDxRIDRq+R0e4t0X8AjU
xbA6Zk+mlQxEzfMOkslmcnKsgO2PM/aOwAKSdJdm70L2UP/H0FoOZq7e5tDOK6OO
wffrEPTucsbI3C7HHrMsULi0IHT6SWIE0U5T5/61KqIJ2xP5KhNn8FbZB6amF4qJ
OaCn/7+3OZMScj2cx86kCAC0Nw/1hA==
=xFhr
-----END PGP SIGNATURE-----

--fR2gx6UElM3+rVbt--
