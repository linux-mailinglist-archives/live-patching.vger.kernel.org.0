Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45FB83DA8FF
	for <lists+live-patching@lfdr.de>; Thu, 29 Jul 2021 18:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhG2Q2E (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 29 Jul 2021 12:28:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231493AbhG2Q2D (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 29 Jul 2021 12:28:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 078AD60EBC;
        Thu, 29 Jul 2021 16:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627576080;
        bh=CvOqRzt/g6Rw1NKHXA+7nr0/VVubdZQ+mfUdQfknYDM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zso5K6vF7iLIIP6lLjyUL9fpnOp3o305FuRnjSxsPmk8K+Ddiy75rUZKv3UExaTT+
         PuFo7E5v2ArPmWHJwGd7x5GgTj17UM7cu3881B5Dbd9dYlLZREQwSkt/jhsh8mZ90T
         Axj4x7cYV7slIkyW4dgbdUVQ68POmWR995wlCRkjYVSWSh4zXnjWhPceOTBMUcUK4i
         Mtt369mlBuAhAJGiMXI1QmhgSkEkzTgEqWNQ8Ig7nyfzqLQGasyoY+yNd0U8WAOxli
         EWuhzaKnQNr1fTWoZFpJK1Eaa47GagKjczycWqpQw43kNDJgTCdF9tzRifYdwZbID7
         Spt2d1PE6vYUQ==
Date:   Thu, 29 Jul 2021 17:27:49 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
        jpoimboe@redhat.com, ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v6 3/3] arm64: Create a list of SYM_CODE functions,
 check return PC against list
Message-ID: <20210729162749.GA51855@sirena.org.uk>
References: <3f2aab69a35c243c5e97f47c4ad84046355f5b90>
 <20210630223356.58714-1-madvenka@linux.microsoft.com>
 <20210630223356.58714-4-madvenka@linux.microsoft.com>
 <20210728172523.GB47345@C02TD0UTHF1T.local>
 <f9931a57-7a81-867b-fa2a-499d441c5acd@linux.microsoft.com>
 <20210729154804.GA59940@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <20210729154804.GA59940@C02TD0UTHF1T.local>
X-Cookie: VMS must die!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 29, 2021 at 04:48:04PM +0100, Mark Rutland wrote:

> For clarity, let's take your bullet-point list above as a list of
> examples, and make that:

> 	/*
> 	 * As SYM_CODE functions don't follow the usual calling
> 	 * conventions, we assume by default that any SYM_CODE function
> 	 * cannot be unwound reliably.
> 	 *
> 	 * Note that this includes:
> 	 *
> 	 * - Exception handlers and entry assembly
> 	 * - Trampoline assembly (e.g., ftrace, kprobes)
> 	 * - Hypervisor-related assembly
> 	 * - Hibernation-related assembly
> 	 * - CPU start-stop, suspend-resume assembly
> 	 * - Kernel relocation assembly
> 	 */

This looks good to me too.

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmEC1wUACgkQJNaLcl1U
h9B3nAf/W+DFa6KhVwLfYCNK/YINgbYkQ2PX6aK5YaXVpNLdubnoFzZRc8SWVXsu
xUvVzMn23qa6iywsltCV7vAoHHI/fBRaeAhytW4lAVXsboBCxYh69l4F7k+3S9+a
kayTQ7uFxwItlvNqUot01COUpggzckyJs71brGRIR41duJI402C0l0wLlMc/2wAr
aqKpI0j6iNKgScKmZCAyRhfrj0ZUBMhS4PgcQwrahC3s06auA+i3Hij0POLEcfvE
+ItAzrC1QdhWErljx0BKYJKvIRbiGSHQvzV6S0iHycE4pnq/t69EVj1FPuUdILGS
lBKOuDyU5wpEM5lxxfrPM0PRu+zm7w==
=s+5z
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
