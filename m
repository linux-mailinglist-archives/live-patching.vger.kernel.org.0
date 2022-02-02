Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54104A7829
	for <lists+live-patching@lfdr.de>; Wed,  2 Feb 2022 19:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236347AbiBBSoL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 2 Feb 2022 13:44:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57314 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiBBSoJ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 2 Feb 2022 13:44:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82C2B61917;
        Wed,  2 Feb 2022 18:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671C5C004E1;
        Wed,  2 Feb 2022 18:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643827448;
        bh=NAxaTKO6chyPoKHaE03yZOtgl4gzZZmyyWH+SanywTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FCJwpSGdfpUK0Hjt0LCaON66mOgzRhsjB1FOXxdRmJRakTtPrkSoF555/qo5Qd9i9
         P+UdvMJ2NWBJjb2RpTa6O1ssqUbvu/StfEcY0v8awXfP5blJtI7QyocF4DtYv1wunI
         PMu7abqADW0uyiCkIUHs/Nu8M1aEeeiOk0V1cjjGgBiqUm0K7SOTql0wcQvb2H6qp/
         Ore0+vPKoQvTX59zUcSIPQsx2P6D6FbScyPBwMb+NOV575eEH9r28DYhRvzMJdzyUk
         VtYPjXsWyE8lGjTMktClGO/6REjxODoZn88xr2Jh8qZ5OC0EHEsjO3OjDI/3y2G2IY
         SGZe1DAyvaFAA==
Date:   Wed, 2 Feb 2022 18:44:03 +0000
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 04/11] arm64: Split unwind_init()
Message-ID: <YfrQ80PE8Nhg8lx3@sirena.org.uk>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
 <20220117145608.6781-5-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lslwmhTcLBqy8I3i"
Content-Disposition: inline
In-Reply-To: <20220117145608.6781-5-madvenka@linux.microsoft.com>
X-Cookie: Quack!
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--lslwmhTcLBqy8I3i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 17, 2022 at 08:56:01AM -0600, madvenka@linux.microsoft.com wrote:

> +/*
> + * TODO: document requirements here.
> + */
> +static inline void unwind_init_from_regs(struct unwind_state *state,
> +					 struct pt_regs *regs)

> +/*
> + * TODO: document requirements here.
> + *
> + * Note: this is always inlined, and we expect our caller to be a noinline
> + * function, such that this starts from our caller's caller.
> + */
> +static __always_inline void unwind_init_from_current(struct unwind_state *state)

> +/*
> + * TODO: document requirements here.
> + *
> + * The caller guarantees that the task is not running.
> + */
> +static inline void unwind_init_from_task(struct unwind_state *state,
> +					 struct task_struct *task)

Other than the obvious gap this looks good to me.  For _current() I
don't think we've got any particular requirements other than what's
documented.  For the others I think the main thing is that trying to
walk the stack of a task that is actively executing is going to be a bad
idea so we should say that the task shouldn't be running, but in general
given that one of the main use cases is printing diagnostics on error
we shouldn't have too many *requirements* for calling these.

--lslwmhTcLBqy8I3i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmH60PIACgkQJNaLcl1U
h9D31Af/RG5xZkB0ADZdcAO8UYG+5BIejei/4/wDs6Tm7XwG40edz/r2xCw36qKi
2d1kgJQqCKFvLfef/Xq5KQ2CWnT2Nhxwa1PzKpvphslEiG8kWb++KjaNFwDMaDJW
HRw16mZxBgOgBR4qdHkKp/tU2e/Unmme/S+yhIwJhrGBLoUrtROg5uA1EtnJtwJE
fYUXVXcXbVcV1tiS22ABFpstyGApitOvt81nsbjkBYae4uUlWcDesx1APvky58Rd
hc5CpXSLDwGzjLBrrqtqmhHPheL/3Ky2XGtHLsI0LXlWbpgejSqJiSXZT695hYby
TdeDSje0Mb3ipzq5g+8K1VmuzaXr9A==
=HcWS
-----END PGP SIGNATURE-----

--lslwmhTcLBqy8I3i--
