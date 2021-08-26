Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551793F8C0A
	for <lists+live-patching@lfdr.de>; Thu, 26 Aug 2021 18:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242648AbhHZQZf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 26 Aug 2021 12:25:35 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:45766 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233834AbhHZQZb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 26 Aug 2021 12:25:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9nLQYbnGN+yi8mzweg9S/BoVh7fXlR4Py2/ta8hD65Q=; b=B5YrvnCAVI2lJ6r7GQ1Ka2YhFl
        WfyqQP3qnVy3QK0DixM0bEOMTzJ6f0lxs2i2jTX0tOE5tg9O1zPjq90AUEMcVnWj8WFo2RvUuwKTv
        1yOUsoWh7EAA53sJ15f5yX7wbyQW8S65Yao6uL7hNFyKJCSut0ojScMPWyv5246t91Zk=;
Received: from 94.196.67.80.threembb.co.uk ([94.196.67.80] helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <broonie@sirena.org.uk>)
        id 1mJHkY-00FUba-Qf; Thu, 26 Aug 2021 15:57:07 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 16BDCD01BF1; Thu, 26 Aug 2021 16:57:04 +0100 (BST)
Date:   Thu, 26 Aug 2021 16:57:04 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v8 3/4] arm64: Introduce stack trace reliability
 checks in the unwinder
Message-ID: <YSe50PuWM/mjNwAj@sirena.org.uk>
References: <b45aac2843f16ca759e065ea547ab0afff8c0f01>
 <20210812190603.25326-1-madvenka@linux.microsoft.com>
 <20210812190603.25326-4-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="DTeBTo7twGoyd0rG"
Content-Disposition: inline
In-Reply-To: <20210812190603.25326-4-madvenka@linux.microsoft.com>
X-Cookie: I can relate to that.
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--DTeBTo7twGoyd0rG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 12, 2021 at 02:06:02PM -0500, madvenka@linux.microsoft.com wrote:

> +	if (frame->need_reliable && !unwind_is_reliable(frame)) {
> +		/* Cannot unwind to the next frame reliably. */
> +		frame->failed = true;
> +		return false;
> +	}

This means we only collect reliability information in the case
where we're specifically doing a reliable stacktrace.  For
example when printing stack traces on the console it might be
useful to print a ? or something if the frame is unreliable as a
hint to the reader that the information might be misleading.
Could we therefore change the flag here to a reliability one and
our need_reliable check so that we always run
unwind_is_reliable()?

I'm not sure if we need to abandon the trace on first error when
doing a reliable trace but I can see it's a bit safer so perhaps
better to do so.  If we don't abandon then we don't require the
need_reliable check at all.

--DTeBTo7twGoyd0rG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmEnuc8ACgkQJNaLcl1U
h9BFrAf+N3yJJQuwCLxv36qPYIv8rK67Wg7vq6QHBv9olYSZOaay2RqDa9LKPVps
cIOnOsjsnjWwchw6R0ynXbK3UvrxZP3Mhl3hN/O0ajYq1ffUxoVzsfiAfLvgDjj1
eK8FP8165XKy6IN7u+OFyomrl7nSKOO4zWRJw5Ce71CcTHnegpxVPb5V4OaMwK28
pOaupCfunPrZyXaHZjpnbZinxAQqtCY/IZU4ztW+0tk78TkK07nbFYUAgmQC9drb
gc4bkfHPdW+L8IUx5fIavhjSiVQHVdes0+u1EAajOmvEYvV8WTklgE0NekkbGPrm
E2aQIY1iWIMZ3PFZnPkx1VYALA/qsg==
=JSFk
-----END PGP SIGNATURE-----

--DTeBTo7twGoyd0rG--
