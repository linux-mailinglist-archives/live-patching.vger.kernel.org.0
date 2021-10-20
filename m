Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61C7434E7F
	for <lists+live-patching@lfdr.de>; Wed, 20 Oct 2021 17:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhJTPFj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 20 Oct 2021 11:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230338AbhJTPFi (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 20 Oct 2021 11:05:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C500D6103D;
        Wed, 20 Oct 2021 15:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634742204;
        bh=vkhyPfkZNo8/42MUDl+ughN91dtEZhhJMRZmgb8xGME=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J/8XNxsmT8o3VQRFR2Emjxu8PRztj4AmMdEjJsxMNvnIGZrjJtj5nGoHFUZsWhp9d
         2fV+65Q0pdBUDFF0sGFUl+VLAgStXsbmzktpl/OBKScT0NAXSFk69miqrQNbKzt1Mp
         wYmlm4OJAET8F6PPWiF8dD7O7iqWpx3mk+5aj5kEj978akauS4DCGmy16WSqiS/pzG
         DBhf12ipcC9RoW7/AyE569p4kBFQ/YPYPe68rtJYXVOYXt0YToKhNWxN74UO/DQyhQ
         6D2j9pQKFSIzJ0ULh2UZJRbb7j4/PWgjyKYFmTHsi3fgIML9e5PLUevt4etp9tfv4k
         1BDCtxFUxBmFA==
Date:   Wed, 20 Oct 2021 16:03:21 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 04/11] arm64: Make return_address() use
 arch_stack_walk()
Message-ID: <YXAvuX7VCVa39eVm@sirena.org.uk>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-5-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="glKU2+UYceKqOWCD"
Content-Disposition: inline
In-Reply-To: <20211015025847.17694-5-madvenka@linux.microsoft.com>
X-Cookie: I program, therefore I am.
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--glKU2+UYceKqOWCD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 14, 2021 at 09:58:40PM -0500, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> Currently, return_address() in ARM64 code walks the stack using
> start_backtrace() and walk_stackframe(). Make it use arch_stack_walk()
> instead. This makes maintenance easier.

Reviewed-by: Mark Brown <broonie@kernel.org>

--glKU2+UYceKqOWCD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmFwL7kACgkQJNaLcl1U
h9CrDwf/RMlpTCaQUTb3tRTLU01209XsV3FL5JxiWYYuBV1TiADSdkySB+XmWszz
wwWlXN+xJHb7Gmyej89P3sXjYGePjCom3daQDVf1CsdlPvHa0VvTjYMliK9VqVGJ
fKaxqrEpyGMaY+Ey7HSFjMgVCUnsLp49azQoCGRe9lUlc9VAW9HKIreAaji+sibz
7CBE7aYtneMnH+GTfpt0zP7KQalqLxJxpcitXVZLypGMuK5f6a4BDBhb/tkS1G8m
6SnVLS5I8t11b8bHZkTW1gdQd6cQzRd19eZQN4H8Wl7VOWpHFdfGb1cQ1EKuDTRY
wn0v2HunMi5dpfltxS1O4W9gtKkxWg==
=c0Sd
-----END PGP SIGNATURE-----

--glKU2+UYceKqOWCD--
