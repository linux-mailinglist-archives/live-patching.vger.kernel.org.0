Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDB64A8326
	for <lists+live-patching@lfdr.de>; Thu,  3 Feb 2022 12:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350245AbiBCLae (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 3 Feb 2022 06:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350232AbiBCLac (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 3 Feb 2022 06:30:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132CEC061714;
        Thu,  3 Feb 2022 03:30:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D195AB83319;
        Thu,  3 Feb 2022 11:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0946DC340EC;
        Thu,  3 Feb 2022 11:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643887829;
        bh=ElkeASgcn6MS/RiiYgEdTkfCoIEA2TIk4cBPoe8jH3g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JXqPaIoq+5cUUqu5WLopiCmfiYYBwado01Iwsf5VmcLhbMdnx+O+wto3u7LHfc35P
         lWdB58KuNPN1lRwzPf0WE3Aj3eR78mT2EhifmmV1iTjW415b4x309iKM80tHQhP87R
         BS7hWekPDSoYhOvu37oUiExkNr4n2ZVO5TgpfrqYDa2Fk9T+jVVqKtzn34iYlQN+04
         ObT+fbpU4zPA/C3LEgmcA5C/x8OqoHuqAAwP29HYV7TmLFhqzY+POr4wqRFuMAcpjD
         NlasCwyJinqoK39/roDpgATzNpkq2I8LDbv+D2dpK+jK1dhy7ffAzoijFEu/rRVn2V
         l3HpAH1bEgRCw==
Date:   Thu, 3 Feb 2022 11:30:23 +0000
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 06/11] arm64: Use stack_trace_consume_fn and rename
 args to unwind()
Message-ID: <Yfu8z5buJvIPvsoT@sirena.org.uk>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
 <20220117145608.6781-7-madvenka@linux.microsoft.com>
 <YfrRoA63/UOXTJc0@sirena.org.uk>
 <48b17c52-58d6-0df5-a50b-35a8ea408998@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="OU6vGcxXH+1e+JAT"
Content-Disposition: inline
In-Reply-To: <48b17c52-58d6-0df5-a50b-35a8ea408998@linux.microsoft.com>
X-Cookie: Prices higher in Alaska and Hawaii.
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--OU6vGcxXH+1e+JAT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 02, 2022 at 06:34:43PM -0600, Madhavan T. Venkataraman wrote:
> On 2/2/22 12:46, Mark Brown wrote:
> > On Mon, Jan 17, 2022 at 08:56:03AM -0600, madvenka@linux.microsoft.com wrote:

> >> Rename the arguments to unwind() for better consistency. Also, use the
> >> typedef stack_trace_consume_fn for the consume_entry function as it is
> >> already defined in linux/stacktrace.h.

> > Consistency with...?  But otherwise:

> Naming consistency. E.g., the name consume_entry is used in a lot of places.
> This code used to use fn() instead of consume_entry(). arch_stack_walk()
> names the argument to consume_entry as cookie. This code calls it data
> instead of cookie. That is all. It is minor in nature. But I thought I might
> as well make it conform while I am at it.

The commit message should probably say some of that then.

--OU6vGcxXH+1e+JAT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmH7vM8ACgkQJNaLcl1U
h9CfQAf+MaUncd9LNQlfnS/OHAXj8zGxyDIr9Gmgjk8pvxAc/r4cuY1K4MTyMrjB
Ab4gWFuINop5WudPHCI5JkE7nZzdd2doX9fhiTMYOEcw068bMkTrtBRkn5GSF6kQ
NHbLxxq6G7DAzqWPnePvL7RX7/IwswqFQvXJ4fOBQ+WmIxBHWJpwdGgLao2F+z8r
DHt+OUpEvHBcf1Hy1P5IkJwnVTsZmeDNf1mOflR33uMicEeWr+3Dj18cEh+1586a
D1VzUVWkDyECv2s0SBzTAlhAcFR3QF3+1OIHZuIwrl2ooxpAgqjWTjjDgURRO65S
Kzgl4MjkmdST0T5OlV/Gi2ApgDTzWA==
=bbIO
-----END PGP SIGNATURE-----

--OU6vGcxXH+1e+JAT--
