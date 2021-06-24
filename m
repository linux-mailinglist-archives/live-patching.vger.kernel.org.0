Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FAA3B336A
	for <lists+live-patching@lfdr.de>; Thu, 24 Jun 2021 18:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbhFXQGQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 24 Jun 2021 12:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhFXQGP (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 24 Jun 2021 12:06:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D5AA613DC;
        Thu, 24 Jun 2021 16:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624550636;
        bh=OF3P2uWCEhmEQpfRSdvmdH/4HqACwBVNZCAwCafDzlU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f3TDSkSeTon+d3w4H7FbVep/Nq32xnhVFPvrFKxuzshVbihsOX0EpKWfq1hrFmTe3
         s2lN6iPU+MKEsg2//QSXcTAliPnHvZ3aBdK5/FUWcU6nMo/zIs0UJp4MXpROReM6aY
         3gzLONm5211Ks3/W+x2RAMruTKi6u8wSvrkmEWxkVc4XnFU7w+p3IuDy4D8SyKq0uv
         bzHOg2FUWDD5gidsBjT3qeFH7AzcWM20uciSxh1dMHB/oJ6Ud46TktvMmwOLtfU6E/
         I/8e3MTHBC6rcrzj4yA6Gy2E1DdMraIm2dhsBBZyOBM1Wt8+xMbh8wf+CUWmDqL3bD
         5m00oiEGs1tcA==
Date:   Thu, 24 Jun 2021 17:03:31 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     madvenka@linux.microsoft.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v5 1/2] arm64: Introduce stack trace reliability
 checks in the unwinder
Message-ID: <20210624160331.GD3912@sirena.org.uk>
References: <ea0ef9ed6eb34618bcf468fbbf8bdba99e15df7d>
 <20210526214917.20099-1-madvenka@linux.microsoft.com>
 <20210526214917.20099-2-madvenka@linux.microsoft.com>
 <20210624144021.GA17937@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="KdquIMZPjGJQvRdI"
Content-Disposition: inline
In-Reply-To: <20210624144021.GA17937@C02TD0UTHF1T.local>
X-Cookie: World War III?  No thanks!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--KdquIMZPjGJQvRdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 24, 2021 at 03:40:21PM +0100, Mark Rutland wrote:

> regular unwinds (e.g. so that we can have a backtrace idicate when a
> step is not reliable, like x86 does with '?'), and to do that we need to
> be a little more accurate.

There was the idea that was discussed a bit when I was more actively
working on this of just refactoring our unwinder infrastructure to be a
lot more like the x86 and (IIRC) S/390 in form.  Part of the thing there
was that it'd mean that even where we're not able to actually share code
we'd have more of a common baseline for how things work and what works.
It'd make review, especially cross architecture review, of what's going
on a bit easier too - see some of the concerns Josh had about the
differences here for example.  It'd be a relatively big bit of
refactoring though.

--KdquIMZPjGJQvRdI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmDUrNIACgkQJNaLcl1U
h9CUggf/f8lTrrP9PgND3uC0n0Z4T+ayRlT9PjEADfX5Ugv2SQjkosWx3UXmW1fM
HodE1+pwLDWJ/rFJrx8KEj/DORPps/PZCyD9Z3iUsRFwnX9M0Zn3TtwU+xKgJmxf
okZ3YcKz84h/Wwv4F4/jsuhygAepVY0mYTAQHGB4zSDKDasVe2IFbq/xkr2uSpcC
+PDIbXNa8Q0Sq2ltLg/dArsHaheHM24HJTWk4tBJlinujj0+uGREYczmdC94ES/a
KIbz/Y8oj35d0LULoWArOB2MpXB/fJWHH6RqE/sk+Zw0ObjbLMLwuGxqhFdOBJB8
LNmjXpF4upK4P8F1y3/8eFnTYt8lCQ==
=UEC4
-----END PGP SIGNATURE-----

--KdquIMZPjGJQvRdI--
