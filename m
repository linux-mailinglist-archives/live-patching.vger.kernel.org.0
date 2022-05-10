Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA635223B2
	for <lists+live-patching@lfdr.de>; Tue, 10 May 2022 20:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348754AbiEJSTu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 May 2022 14:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348890AbiEJSTn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 May 2022 14:19:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E062B52C6;
        Tue, 10 May 2022 11:15:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CAA961AFD;
        Tue, 10 May 2022 18:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F883C385A6;
        Tue, 10 May 2022 18:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652206511;
        bh=VIBVcwjyo7mXs7/cLCcqyRqJzfOhOX/AHUyka9JqqoU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XE0o0SfLqqhE0ZDyvHRMT2rMu5YLOworrGQsrzJcfr19s2br+nteuT0lXarYoNzK8
         JxtMiFEbwBwFH6kAazlK+38ADbpncT1bRow6NIBFyzX6LzJBmYyAOKbRQDPIxgmXfM
         /QiFrPpONgTtA+EHOjAu4sHbUWAl5NtDm1CzYvRWyiF6Td5DaM9MhG7LpwLl92vMwY
         G/lkj1ep+/lhMVrY6pjJeODBPJnoozNypQ3fakMFLp/jkrynyL3sZp/IcvF3SCWPOO
         fPJdWxkiKq9VH1iNU0VLUCR1fuViKAMMFPTqnOa+sFq9JAZrdiD9u0EyTH7m+yT6y7
         /9qitzTNayXMA==
Date:   Tue, 10 May 2022 19:15:04 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v14 1/7] arm64: Split unwind_init()
Message-ID: <YnqrqI/Xdq9RMwoc@sirena.org.uk>
References: <f460a35f88195413bcf7305e5083480aab3ca858>
 <20220413140528.3815-1-madvenka@linux.microsoft.com>
 <20220413140528.3815-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="S1gfJnV9doaxbnA7"
Content-Disposition: inline
In-Reply-To: <20220413140528.3815-2-madvenka@linux.microsoft.com>
X-Cookie: I've read SEVEN MILLION books!!
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--S1gfJnV9doaxbnA7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 13, 2022 at 09:05:22AM -0500, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> unwind_init() is currently a single function that initializes all of the
> unwind state. Split it into the following functions and call them
> appropriately:

Reviewed-by: Mark Brown <broonie@kernel.org>

--S1gfJnV9doaxbnA7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJ6q6cACgkQJNaLcl1U
h9Bg9AgAgl+At82Yt7N4YFfo4vqhuLFjD/f8TsuKv01xPB7ZGnlmbPsWJg+9l7h/
FukrNbDpta6SMamILiT9VfsPoxpKaukQXNeNKfDmshGimH8rXVLzITIwRt3+2sE6
+fyIUvrWnGLUYmW3FMgAMXvZ5eGypo3YTA5IknFQLfD5pOQbgMUO2rucC9ncDd6P
//T4rX9KbzJOEL89CSApDP8yihbSEDjbrHQAgL8yHz8QBaiXix3Kn4jdvqF58vf0
OilJ7GZeO3a8x6mUaO6l8oX+h1vWwlcb0DXrxb046XN3GDv3sTMnQLy9N/+F6npK
6HWk/mEdAedGpbJZaWxpq/Y9jR8HPg==
=iN7k
-----END PGP SIGNATURE-----

--S1gfJnV9doaxbnA7--
