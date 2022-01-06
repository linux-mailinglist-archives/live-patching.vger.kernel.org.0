Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86A94863D0
	for <lists+live-patching@lfdr.de>; Thu,  6 Jan 2022 12:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238606AbiAFLnn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 Jan 2022 06:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbiAFLnn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 Jan 2022 06:43:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD68C061245;
        Thu,  6 Jan 2022 03:43:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83DF0B82072;
        Thu,  6 Jan 2022 11:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F00C36AE5;
        Thu,  6 Jan 2022 11:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641469420;
        bh=I2aHLNpSbtDknB3iBi0Mt5srrLAzwYs3Vfj7t28MM1E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bT7ApK0OCOWO1jD4+661OlccaQwj4f1QlYbntqRaTvQo2eLHKUMbrTf38cgJcdBrh
         IS0aS76q3f1NeVO12QmwD34HCQYZWDexlPBZW0s8+GcZ/GTlfsP3G8HZet8+ofXrnk
         6uSyyif03uiKX+ekG3ymdFQ+stehKttUUX7Yg8AV0g1mH7EiiNoa4R2j5MeNh+pRL3
         1OPyr637EtYIKPwj0HIJVmakjSLb5ahOP/C8z/wj4pnmLoHluy8GZ/xtiX67g1NB+f
         pag2WU4yz3TQHc13x2rHV/BLHOlW6sUGPVfIhl3WUDXAHBBPfcLFqP0cpSR1qed2Po
         sjn8u9uxw1IUQ==
Date:   Thu, 6 Jan 2022 11:43:34 +0000
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 07/10] arm64: Introduce stack trace reliability
 checks in the unwinder
Message-ID: <YdbV5p9ZF3qjb1dc@sirena.org.uk>
References: <0d0eb36f348fb5a6af6eb592c0525f6e94007328>
 <20220103165212.9303-1-madvenka@linux.microsoft.com>
 <20220103165212.9303-8-madvenka@linux.microsoft.com>
 <YdXOQTXscVaVFMJ3@sirena.org.uk>
 <85156eb8-df63-29c0-cbfc-37bc0356d9e8@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nkAb5dHSgKTMYvOv"
Content-Disposition: inline
In-Reply-To: <85156eb8-df63-29c0-cbfc-37bc0356d9e8@linux.microsoft.com>
X-Cookie: I think we're in trouble.
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--nkAb5dHSgKTMYvOv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 05, 2022 at 05:58:59PM -0600, Madhavan T. Venkataraman wrote:
> Thanks for the review. Do you have any comments on:
>=20
> [PATCH v12 04/10] arm64: Split unwind_init()
> [PATCH v12 10/10] arm64: Select HAVE_RELIABLE_STACKTRACE

Not yet. =20

--nkAb5dHSgKTMYvOv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmHW1eUACgkQJNaLcl1U
h9CPVAf/QaMTLGTeMvBiS5vqudjFC9nBuusjkrEo8aDfS0ykawOlusSdW4bgjQNS
nfUwlMS+QNR3tXocVKS6VCnJokflrSxsAz/eXYgXxt+98xnNoaaYx06I6IQsxVcX
ekJu9P8Ouyunc//7TxagxveOwsaLr53/wv8kKAyYGIZTj9JZHvG8v3JOKf1Xdcas
6Z64w1XOvbDweyfZQtD/A+VXqlX0tVZ0z9wtqbMppxivRYdE0h/yUxekNQ1gzz8S
du5wxUo6r3tE39IMFrKimQjjSErL5lOdul/PNS22BFQO5XmWEjD5aGz34krYXtEh
RsJ+kfSlx277uL8V4zo4Zx/WIFdYNg==
=mryq
-----END PGP SIGNATURE-----

--nkAb5dHSgKTMYvOv--
