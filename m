Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79473362588
	for <lists+live-patching@lfdr.de>; Fri, 16 Apr 2021 18:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhDPQSe (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Apr 2021 12:18:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229706AbhDPQS3 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Apr 2021 12:18:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABF44611C2;
        Fri, 16 Apr 2021 16:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618589884;
        bh=yswrIjjmn2e3nKV27uayw2k8/pr20uT4hb5GOJsSVB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DHjp8BqraDpMSxo3lldnMJ8Pv/3+IwXD1i51pwRbteyzNBQCyacnBhKpQnKx0G0TU
         0ye7rIM78qIydTtFSxabMF66WQkhv+THBeWhxCZNroRqbZb4v/74IQMHtthmnd63oD
         fU0SLoz06DteV3F8C4WMLGqqnZjrgKfRMAdOdXcazsd9yWLOyXD1K2j7h1dRDO8DIz
         HgJSEwIitVCYfQzSfIG0toA6WDkelVoeZqbr6i3CrYLlG3ZJmItxcNqrkT52vO9UG+
         QrMfXZLXImUIJFDUvKP9hA6fba8FumiCqfkc1UwSN6TfPi7yYf1VvCdTaSrq0GOMwl
         BEevDggqHHgzg==
Date:   Fri, 16 Apr 2021 17:17:40 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/1] arm64: Implement stack trace termination
 record
Message-ID: <20210416161740.GH5560@sirena.org.uk>
References: <659f3d5cc025896ba4c49aea431aa8b1abc2b741>
 <20210402032404.47239-1-madvenka@linux.microsoft.com>
 <20210402032404.47239-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="TBNym+cBXeFsS4Vs"
Content-Disposition: inline
In-Reply-To: <20210402032404.47239-2-madvenka@linux.microsoft.com>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--TBNym+cBXeFsS4Vs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 01, 2021 at 10:24:04PM -0500, madvenka@linux.microsoft.com wrote:

> Reliable stacktracing requires that we identify when a stacktrace is
> terminated early. We can do this by ensuring all tasks have a final
> frame record at a known location on their task stack, and checking
> that this is the final frame record in the chain.

Reviewed-by: Mark Brown <broonie@kernel.org>

--TBNym+cBXeFsS4Vs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmB5uKMACgkQJNaLcl1U
h9CPPQf/R3UwmJLdpgf5bWS8YnjCBSQrbExv+cVuzLF4z7KKClkFKl3rW90bcMjE
EVqv7sZdhh7q/E9GL1GAsHyFTeaHEIf0zGcqzT05cLJm35tYbzAskAWDrusK+/Vq
Z6SZq307HFmj7XZHdira47AMGCfnsVNJWykBNUtxyee57LfRH88p0HD6oQ7VGu3q
29ASaCUlbo1EcZMVWH/Jat0wNa2O+rOPNg/gUzGiSKa6Tr3/g7XVG6+PlOkE256l
m2e9N0t/gK9KnDBD7z8CHb+zZ+ouweovBbt4R6HP4HSJFhC5+sgH416PnUk0dQKx
V5K2XonwCkNXVfZFkLlHPbo+yykS3w==
=UVjj
-----END PGP SIGNATURE-----

--TBNym+cBXeFsS4Vs--
