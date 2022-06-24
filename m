Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC9AF5598AF
	for <lists+live-patching@lfdr.de>; Fri, 24 Jun 2022 13:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiFXLmh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 24 Jun 2022 07:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiFXLme (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 24 Jun 2022 07:42:34 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094467A1BF;
        Fri, 24 Jun 2022 04:42:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 470E5CE2670;
        Fri, 24 Jun 2022 11:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC80C34114;
        Fri, 24 Jun 2022 11:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656070949;
        bh=A9EbR0TTckgQYks+j0SLebZoHLsX7+FVTH3QCZLBNLI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lfAalIbsPwoYEqi/eNoEEg1XzTA80iuuuHjDWGSr+GpUJkK/uLurfchn3GmDl+VqU
         I5dzMOTCwocH0S4rK9pBaRu26LTcnt7NBRaiLQKNdT6LYS0d7P4wg9CqE+4ra4BHm6
         Qbfzq1E8mIw8KEHX1VOPrYqTGJ9T8XW7+r7un5n1wTMyQzBekMq9/agKoRR3qunO/O
         OGt2rl8mi+rHQ1bj3gl2UBO9PXRMuVJiHRunmSmRbk3kAgD1XZDW8cOP8J8DNpUgeY
         u/4YoR0xOt9my1L/DSIl4JNJrsNi3+qhjQ0QXSpFNAgTmINbL9CyYwubXia8CFVtGm
         GJ7A2EjvNT76w==
Date:   Fri, 24 Jun 2022 12:42:23 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Will Deacon <will@kernel.org>
Cc:     madvenka@linux.microsoft.com, mark.rutland@arm.com,
        jpoimboe@redhat.com, ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v15 0/6] arm64: Reorganize the unwinder and implement
 stack trace reliability checks
Message-ID: <YrWjH4H7KxLAqfph@sirena.org.uk>
References: <ff68fb850d42e1adaa6a0a6c9c258acabb898b24>
 <20220617210717.27126-1-madvenka@linux.microsoft.com>
 <20220623173224.GB16966@willie-the-truck>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="TK6aEfPqnhW4wFA2"
Content-Disposition: inline
In-Reply-To: <20220623173224.GB16966@willie-the-truck>
X-Cookie: Help!  I'm trapped in a PDP 11/70!
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--TK6aEfPqnhW4wFA2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 23, 2022 at 06:32:24PM +0100, Will Deacon wrote:
> On Fri, Jun 17, 2022 at 04:07:11PM -0500, madvenka@linux.microsoft.com wrote:

> > as HAVE_RELIABLE_STACKTRACE depends on STACK_VALIDATION which is not present
> > yet. This patch will be added in the future once Objtool is enhanced to
> > provide stack validation in some form.

> Given that it's not at all obvious that we're going to end up using objtool
> for arm64, does this patch series gain us anything in isolation?

Having the reliability information seems like it should be useful in
general even without doing live patching - we can use it to annotate
stack traces to warn people about anything that might be suspect in
there.  For live patching it's probably something we'll want regardless
of the use of objtool, it's one more robustness check which always
helps.

--TK6aEfPqnhW4wFA2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmK1ox8ACgkQJNaLcl1U
h9AEiQf/WqiaUGRvZs/gEhhSFRXD9HBwdbVf2Yd0sL2zEILXUI9Ld3PVgtxktJyV
05a7Vrm2cj70mtTa9hgXijXG/TdpR1fdGVv+3fOe0PnH6yQQbywUrk/mk2HgmhqE
56t0MyabelWk9fN2+WqqRtbdko0mCxNE9d/gjH+SaggSuqVEb6WyrwNkb0XA7XlG
dtNaq76s0mkYqx4owIkSjQouuJeQsy+1Hn2bcbbNa2c7ra/1zL4KOT9cTrK0zDdD
usmOBhDorWpVeUNkg35q3OoQ+bh4cyLaipMQGVl2wEtGz6ODyBDzGGumHxGZf9Tg
Z/RjJXHtd4LShvPqKsS9Pzjdpr9V+A==
=j8JN
-----END PGP SIGNATURE-----

--TK6aEfPqnhW4wFA2--
