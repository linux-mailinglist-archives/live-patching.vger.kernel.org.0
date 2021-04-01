Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A96351879
	for <lists+live-patching@lfdr.de>; Thu,  1 Apr 2021 19:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbhDARpx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Apr 2021 13:45:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234618AbhDARi0 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Apr 2021 13:38:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A813613D3;
        Thu,  1 Apr 2021 17:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617297687;
        bh=mt7mSirjIpb9HBVKFPaqTQQ9E7aJaJ2v+9YGh4vH1pc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AjmtXXhvPL/YkPYR+EP6yFc2rsVIHmWXOmMLwxaClD0+GhQRm50xeUbalniniE+5E
         WIA4yHbfQvXgweSofogr8XoGUS0pT2/ki2bkO4XmYPfJ0RMSdWbJ+dbYmCiovpr4dN
         /8pwfA5V89gemlh/xK1dyF80PkxzaRmQVsOa5i/Yh6N12cXhxQVbzdqPCkIYds4Ps3
         Y1WLisYr1jAdyONZ1oza3FP6izLmoo8oC/hQntyvbra0m33Pb/V/VCAA98yLQ0kE07
         9UBCFZTcOWePlMGhQOqV1/D7tjavZPPQQuySsAQTZcSUhJa4+K3vQJrLLn0aEOOR+t
         pY/f8mqNG39fg==
Date:   Thu, 1 Apr 2021 18:21:14 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 2/4] arm64: Mark a stack trace unreliable if an
 EL1 exception frame is detected
Message-ID: <20210401172114.GM4758@sirena.org.uk>
References: <77bd5edeea72d44533c769b1e8c0fea7a9d7eb3a>
 <20210330190955.13707-1-madvenka@linux.microsoft.com>
 <20210330190955.13707-3-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pP0ycGQONqsnqIMP"
Content-Disposition: inline
In-Reply-To: <20210330190955.13707-3-madvenka@linux.microsoft.com>
X-Cookie: You can't take damsel here now.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--pP0ycGQONqsnqIMP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 30, 2021 at 02:09:53PM -0500, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> EL1 exceptions can happen on any instruction including instructions in
> the frame pointer prolog or epilog. Depending on where exactly they happe=
n,
> they could render the stack trace unreliable.

Reviewed-by: Mark Brown <broonie@kernel.org>

--pP0ycGQONqsnqIMP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBmAQkACgkQJNaLcl1U
h9C2SQf+NvIsAlsof26aZkOkpChuEOFcssNFTBsVHHOMiPLp6iY2W0CkN+qGkxI5
J4lpwbAsj/LmRo7CIZgihzCAR4aPOOe2+c5qnJuRoZ3J1kZfXtKpkxwYxxkSH/wx
o9eLE2S4xm9wiMXmEYSqahP5HNhTQgDHI//ixyxTszsA5HMAXclHq6P3x5KhJH/a
P0ktUZPGIgP1XwZd4loFkM0JOeYHNgwtIcWoACyEISnRsBCI4gcFoEuOTrswzVL5
feInfKQkzYebhWaEC8qUBPbawEWfmIn+sMfDKBx83OsCs+mqTeDrBbu8D9xngOjz
dW6HR5po7mwhDy0AfmP6CCdsDDAmBg==
=JPNJ
-----END PGP SIGNATURE-----

--pP0ycGQONqsnqIMP--
