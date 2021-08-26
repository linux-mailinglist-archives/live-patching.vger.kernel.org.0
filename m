Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D3A3F8C07
	for <lists+live-patching@lfdr.de>; Thu, 26 Aug 2021 18:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbhHZQZ1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 26 Aug 2021 12:25:27 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:45722 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238124AbhHZQZS (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 26 Aug 2021 12:25:18 -0400
X-Greylist: delayed 1761 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Aug 2021 12:25:17 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YpAC7eKIN1Mk1gt9e5fi3Ne1IF3XO4Cc70sDdq2XPuo=; b=Zza36yh1cVUFJ/wznsXo2osjWg
        qhweHSI/W3yFCGaHmPXuQQW6mCme31KjL5zFck+2gmfVyODZdylB4GOfU05DzYyjnfBF+FiNC1XzH
        1J8Rx/0wxfA1WyyLrBq32bP9AJ6+KR3zbRA5QhoCxtpBGHrLC4ZuAbHTtDaflLgQNiLs=;
Received: from 94.196.67.80.threembb.co.uk ([94.196.67.80] helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <broonie@sirena.org.uk>)
        id 1mJHiM-00FUXp-QF; Thu, 26 Aug 2021 15:54:51 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id C7C89D01B81; Thu, 26 Aug 2021 16:46:34 +0100 (BST)
Date:   Thu, 26 Aug 2021 16:46:34 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v8 2/4] arm64: Reorganize the unwinder code for
 better consistency and maintenance
Message-ID: <YSe3WogpFIu97i/7@sirena.org.uk>
References: <b45aac2843f16ca759e065ea547ab0afff8c0f01>
 <20210812190603.25326-1-madvenka@linux.microsoft.com>
 <20210812190603.25326-3-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="65LKdjdOaAfSQ4/m"
Content-Disposition: inline
In-Reply-To: <20210812190603.25326-3-madvenka@linux.microsoft.com>
X-Cookie: I can relate to that.
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--65LKdjdOaAfSQ4/m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 12, 2021 at 02:06:01PM -0500, madvenka@linux.microsoft.com wrot=
e:

> Renaming of unwinder functions
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

> Rename unwinder functions to unwind_*() similar to other architectures
> for naming consistency. More on this below.

This feels like it could probably do with splitting up a bit for
reviewability, several of these headers you've got in the commit
logs look like they could be separate commits.  Splitting things
up does help with reviewability, having only one change to keep
in mind at once is a lot less cognative load.

> Replace walk_stackframe() with unwind()
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> walk_stackframe() contains the unwinder loop that walks the stack
> frames. Currently, start_backtrace() and walk_stackframe() are called
> separately. They should be combined in the same function. Also, the
> loop in walk_stackframe() should be simplified and should look like
> the unwind loops in other architectures such as X86 and S390.

This definitely seems like a separate change.

--65LKdjdOaAfSQ4/m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmEnt1oACgkQJNaLcl1U
h9DPnAf9F4laW3vdmWRoJzkB/XwlR1FibFKsnO7ddA+FYMKZuJKT88RuCyy/oIdd
/h434cxFWIKloXHHoVJEnN5PsOCbiyeddB+maWA5TNP7zI53+l15rrgHvLxpJ6nW
w0hcLJRt4vvlv/1QJsW1q5FqvXkBx9WDlJ142fpX0/yH07rm+oxi4Ib4jX3E7rQL
d2R0vgSZNXN4MLoyTaOnNdjX84zz17rFN8l7Gl2iO4dWYj9nLjFWgRY6icoGcVWh
OgDIxg2F4D78vOCN41EsPe6ZYtNzBKAp+9DF9KH4qea9uMMiCJlhCJJNzVGWzBN6
wFffVTt+3zbPngMhDDGDSWNO7nkCIw==
=cnd8
-----END PGP SIGNATURE-----

--65LKdjdOaAfSQ4/m--
