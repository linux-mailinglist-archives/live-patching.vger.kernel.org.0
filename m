Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8264A4A782F
	for <lists+live-patching@lfdr.de>; Wed,  2 Feb 2022 19:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238229AbiBBSpc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 2 Feb 2022 13:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiBBSpb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 2 Feb 2022 13:45:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51F8C061714;
        Wed,  2 Feb 2022 10:45:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 017586190E;
        Wed,  2 Feb 2022 18:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5123C004E1;
        Wed,  2 Feb 2022 18:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643827530;
        bh=LXUkGgNURUaWtPUNNww4eQy5zJcsZMaM1D6It5AgNZY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ueZqHhCERM/aialzCwztWmIeNHXJBMcunsYNQAkikg99LMDU/tvJv/DH8NZF9F/yV
         1F3jDRMQ8i+TJkuJxdXVcOh3u72uFpxUT7pNHyNSq79OerKbqL//tJ/In9wJpyXr4L
         bRMXr6JU3TylnDmkUYTIR3CUSGE/8r1MJklJ/e1OJLcKrNqsEjj06h76kNmKBmhVYN
         9IJQ+SQiUlZK8HGiH8J5riNHk63ncyjGNvzsxtfUE7YvxYwJU/FJCUcyTktC5mgyxq
         9y3wKmh8KpYuLgyKhrzwVh8zh6+Z8fDBT2hfLvt2opZrxls8zaje5JPRuu7VtQNO3H
         9BXKgxHaNG+bQ==
Date:   Wed, 2 Feb 2022 18:45:24 +0000
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 05/11] arm64: Copy the task argument to unwind_state
Message-ID: <YfrRRCDZn75GSb/3@sirena.org.uk>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
 <20220117145608.6781-6-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ArnKv5r9+Aqpo7jE"
Content-Disposition: inline
In-Reply-To: <20220117145608.6781-6-madvenka@linux.microsoft.com>
X-Cookie: Quack!
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--ArnKv5r9+Aqpo7jE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 17, 2022 at 08:56:02AM -0600, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> Copy the task argument passed to arch_stack_walk() to unwind_state so that
> it can be passed to unwind functions via unwind_state rather than as a
> separate argument. The task is a fundamental part of the unwind state.

Reviewed-by: Mark Brown <broonie@kernel.org>

--ArnKv5r9+Aqpo7jE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmH60UQACgkQJNaLcl1U
h9BPLQf/SX18HDRfP+E0g4Luh+9b/vSRXqrtiDkqa8cFUAOpSKHR8zuU0bPp/Byf
BDI1wf8j427JLgnvrUplLiI/q550A9SWCQrcqBMOnY4FUfSc/iHiNw2reTeXwgkn
Pfu5dSUCRRI/B09poPyasm+dBhJ7Ewn0SJpgs/gBLRHYmS1ZeHM9y0yO5o+ilXsZ
HkHXnBD8mXbTmpE1KRSbpicsdQ2B6U/WsjXOWUlh4JpbqxzB8xnx6gBbDbsH5V6P
YQuoH7ZOuYlOOlaTR7oGk9KCi6rUOM75/cJPg3wsXwo5iUNEUvQCiXykh8SHUjR7
UbQpMeRSdusKcRkxkz0QNfmYfXfOKg==
=WWtK
-----END PGP SIGNATURE-----

--ArnKv5r9+Aqpo7jE--
