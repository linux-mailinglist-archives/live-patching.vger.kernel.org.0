Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BFB3FDFB7
	for <lists+live-patching@lfdr.de>; Wed,  1 Sep 2021 18:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245121AbhIAQVf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 1 Sep 2021 12:21:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234245AbhIAQVe (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 1 Sep 2021 12:21:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34D56601FD;
        Wed,  1 Sep 2021 16:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630513237;
        bh=rsd7nCqgXJ2jWgs1sLYpLUt9ooxJDLlhdHsdL81YIUk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sllj1aObUXyo5mzEZtQ7Nka0M+slcIpcekutusSjQ1azodImlPKerDfnABjrIXIGH
         rAcNusIeZbog2YN62BeMh/Xy62IsApTQHH4DMhwPH5KeW3b7TGx74ShTRaUTB+YXkD
         Jpu2VXOzq+LmiJH8xCTcpU8NqwtWmZQNztuKLnQi9fVcgw7vI1Utis85lxHHzZT0H0
         KT25Zk2cdoQGh0NQNDtycbEnwIr9yuSkoMCUzl4gtVjSpNFBq22GPXgaemN6gKJpFO
         qAM30rkmpKlLBGAiGmt8WvtnvLlb1HocFvzKZQOVLZVx+t9azc7/fJzAt53+HlXvc/
         nd0nEx55DBViA==
Date:   Wed, 1 Sep 2021 17:20:05 +0100
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v8 2/4] arm64: Reorganize the unwinder code for
 better consistency and maintenance
Message-ID: <20210901162005.GH5976@sirena.org.uk>
References: <b45aac2843f16ca759e065ea547ab0afff8c0f01>
 <20210812190603.25326-1-madvenka@linux.microsoft.com>
 <20210812190603.25326-3-madvenka@linux.microsoft.com>
 <YSe3WogpFIu97i/7@sirena.org.uk>
 <ecf0e4d1-7c47-426e-1350-fe5dc8bd88a5@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qOrJKOH36bD5yhNe"
Content-Disposition: inline
In-Reply-To: <ecf0e4d1-7c47-426e-1350-fe5dc8bd88a5@linux.microsoft.com>
X-Cookie: Who was that masked man?
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--qOrJKOH36bD5yhNe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 26, 2021 at 06:19:07PM -0500, Madhavan T. Venkataraman wrote:

> Mark Rutland,

> Do you also approve the idea of placing unreliable functions (from an unwind
> perspective) in a special section and using that in the unwinder for
> reliable stack trace?

Rutland is on vacation for a couple of weeks so he's unlikely to reply
before the merge window is over I'm afraid.

--qOrJKOH36bD5yhNe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmEvqDQACgkQJNaLcl1U
h9A0cAf/SoHI8fwUIQSaFrtvXtb4jGfHiTu1fTupPugI2N6ZAujXJn+c/h7nfg6n
OJGrHBqwlObt4w5SUzC54NSfVBL4CRAHD8QQtCLgJtG2t5RwMqJdDPZH6TS1KEo8
2Hrp3pLFOWVzDL2jh5fX6RA/ncK0a/eqbBmTkZQJtfg1s/AWKKHCtZQRM0eqnDVO
KB0KQ8s8CZ3RgwVwIoddS8vTKm2Jjra/hLof2HFxxSRAVNUO+AlpEFIifsaaABFj
w+MgHHISeYO2Niu9QurFM6M98J4WEnSMd6Un3xk9EHjRRrc25soEbaip0+wsUa1U
03zK0j6jLrBB5Hm8iwr4xaN/CU7mdA==
=nGZk
-----END PGP SIGNATURE-----

--qOrJKOH36bD5yhNe--
