Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21AF249D08A
	for <lists+live-patching@lfdr.de>; Wed, 26 Jan 2022 18:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243652AbiAZRQZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 26 Jan 2022 12:16:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51494 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243650AbiAZRQY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 26 Jan 2022 12:16:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20D1161923;
        Wed, 26 Jan 2022 17:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F19C340E3;
        Wed, 26 Jan 2022 17:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643217383;
        bh=aR5TTg+yX2ncUu2adEk0kEJ2Fb368DAANpS08G5wYEo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kDm7Qz+623bPk2g1lVdMwhk4OwhthiEtOBCqN0ktL2R/nB4cLFCqs264tgN0jIsXN
         Mq3SbKnntVhu6gVy2z76lqokQq80IL0JcQNAogisF4HDBhL92rEjPoxAitIc9uTlsZ
         zOhdYKPSo4BXkm9rQa3byzo4nySvQ8OrO7xGMi5A3YXIMKNIBkggACXDeUmriYJN0x
         WRqNmIXON0rl7DNEeX0JBhMGLw7eOF9s/x6d9ezZbL70RFxebKfBfiB27Nl0kQ+Q19
         7g06pKPL9WDUnZ74EtKHiMDGrFc7xBx47SLM/tEB2hsj6nV3omkFzR/yBctHXzx5F6
         A2aE9RbsZQgCw==
Date:   Wed, 26 Jan 2022 17:16:17 +0000
From:   Mark Brown <broonie@kernel.org>
To:     "nobuta.keiya@fujitsu.com" <nobuta.keiya@fujitsu.com>
Cc:     "'madvenka@linux.microsoft.com'" <madvenka@linux.microsoft.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "sjitindarsingh@gmail.com" <sjitindarsingh@gmail.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 11/11] arm64: Select HAVE_RELIABLE_STACKTRACE
Message-ID: <YfGB4RnMjl9W6iso@sirena.org.uk>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
 <20220117145608.6781-12-madvenka@linux.microsoft.com>
 <TY2PR01MB5257518B8EB381E16D52B244855F9@TY2PR01MB5257.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="v039aBggoL9WPPvU"
Content-Disposition: inline
In-Reply-To: <TY2PR01MB5257518B8EB381E16D52B244855F9@TY2PR01MB5257.jpnprd01.prod.outlook.com>
X-Cookie: Use only in a well-ventilated area.
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--v039aBggoL9WPPvU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 25, 2022 at 05:21:27AM +0000, nobuta.keiya@fujitsu.com wrote:

> I know that Julien Thierry published objtool support for arm64 [1], but I'm not
> sure if it has been updated. Could you tell me other threads if you know?

I've not heard of anyone else picking that up.

--v039aBggoL9WPPvU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmHxgeEACgkQJNaLcl1U
h9AeZQgAhE1zfok88S69ExiVCwo4qLkMK0qP4cXtzuzVw5i8WAyR0aP0xtfIZg5J
x+Qwu0HOFe2OazXVO+nY6ggC2WhT4Mhk2w3269rN6jnvlTifJqVBHNqseJBtjrWV
ULmrweCzOb81LQJwfn69LXusz+aqXeAKHT17924Pd0zGbRhgpObSKCdTwbZBxoWI
pc6kZNu/Sq3z8FP6Up66BOum8+l8wKhIEsdHQm1TZHud+P+9+no0t545XKJbddTQ
ytQeVNOes799bzJAF/DKIUvJHDUr3GKx7Z/ZVLYfcPlimNpIk1H/FP/9YDxRHWsk
yhkqb/PkS+UpJzyMismn+sLuvXPtRw==
=sDH5
-----END PGP SIGNATURE-----

--v039aBggoL9WPPvU--
