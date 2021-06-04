Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C671939BDD8
	for <lists+live-patching@lfdr.de>; Fri,  4 Jun 2021 18:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhFDRBo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 4 Jun 2021 13:01:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhFDRBn (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 4 Jun 2021 13:01:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3A78613E3;
        Fri,  4 Jun 2021 16:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622825997;
        bh=oy91zHyeWFBR/8w6AyBF+OCwrD1WZiRJ8FRdiKTuQqI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ADXZmoNwtLICjuUk8BKk7G7Sn/xPd+xGBvgfPNa1buqZ5s7ymG8fFFBm4XDmHleCp
         UG2ah5vUf+/9ofJnfONMsZGXqekSRlbXmU7Et+gZ937iTcymPem9/GdYi8u91VZRjS
         vpJeLmB57RqlpLYUdthc7gZ5ddE0n4vyOe+olNExDzAlRoXc6/Jqlu4WHyAXBegups
         2uHPcZBqrqv8ffxEd+eCKmXDbtSxS5KKwq8dixYs3SxK9oM7GYGMYPjK5ucTJJWBYv
         aW9z2c9t8eMl5cPRfSH+AWGb9B+FtuFy04iRwovHyS7UGAvXLu6CXiJFkYbhzDt8aU
         sDpITrpvWAY+Q==
Date:   Fri, 4 Jun 2021 17:59:45 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v5 2/2] arm64: Create a list of SYM_CODE functions,
 check return PC against list
Message-ID: <20210604165945.GA39381@sirena.org.uk>
References: <20210526214917.20099-3-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <20210526214917.20099-3-madvenka@linux.microsoft.com>
X-Cookie: Auction:
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 26, 2021 at 04:49:17PM -0500, madvenka@linux.microsoft.com wrote:

> + *	- return_to_handler() is handled by the unwinder by attempting to
> + *	  retrieve the original return address from the per-task return
> + *	  address stack.
> + *
> + *	- kretprobe_trampoline() can be handled in a similar fashion by
> + *	  attempting to retrieve the original return address from the per-task
> + *	  kretprobe instance list.
> + *
> + *	- I reckon optprobes can be handled in a similar fashion in the future?

Note that there's a patch for optprobes on the list now:

   https://lore.kernel.org/r/1622803839-27354-1-git-send-email-liuqi115@huawei.com

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmC6XAAACgkQJNaLcl1U
h9AmswgAhOf2VOY3fAiB5KkSryDhSWd3yIPNpRsIYiepRmDE0pyVzzYnyl4DxK/G
PGvN/Wi7Uzu36mHgAA5qCka1F4gm6RN8yLbtGbvtV6fqvTE+N0LvHYt3zNhyZjix
KhK2sFjE9bNNg7S/ZM8whyXqhPoDOtfmxgGSiuHNwh5Lbcfsl5HO1AJD02r/nbnz
RqOCV1VcSnWit9AoMZLSfhkFCf4/G5PlijB6x1PkvWNAtsyM1NE61/a/HFfhwGkt
ZbeuD0xBZMone+oCqNqFyslfhdj3iHBMUntYtuADIugheBEhf+L6H7yLU/CrLx5w
CoDOftD29KUJUDdFdBuQ6QndSk4HhA==
=cks7
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
