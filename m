Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81CF9520AD6
	for <lists+live-patching@lfdr.de>; Tue, 10 May 2022 03:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbiEJBwl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 9 May 2022 21:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbiEJBwl (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 9 May 2022 21:52:41 -0400
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B78140F8;
        Mon,  9 May 2022 18:48:45 -0700 (PDT)
Received: from imladris.surriel.com ([96.67.55.152])
        by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <riel@shelob.surriel.com>)
        id 1noEzN-0001Mi-5T; Mon, 09 May 2022 21:48:37 -0400
Message-ID: <5c3b6c2fc875708f1452b32416235247e11296af.camel@surriel.com>
Subject: Re: [RFC] sched,livepatch: call stop_one_cpu in
 klp_check_and_switch_task
From:   Rik van Riel <riel@surriel.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Song Liu <song@kernel.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, mingo@redhat.com,
        peterz@infradead.org, vincent.guittot@linaro.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com, kernel-team@fb.com
Date:   Mon, 09 May 2022 21:48:36 -0400
In-Reply-To: <20220509200949.vzx4g5xpebomkok4@treble>
References: <20220507174628.2086373-1-song@kernel.org>
         <20220509115227.6075105e@imladris.surriel.com>
         <20220509180004.zmvhz65xlncwqrrc@treble>
         <68f91fb233d5bf82e29cc5c6960a62863b297db3.camel@surriel.com>
         <20220509191745.yk2txsa4cv3ypf6k@treble>
         <1f94c48b4e0e7d73a689a076f78f0892095b4d89.camel@surriel.com>
         <20220509200949.vzx4g5xpebomkok4@treble>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ilNaoEj4DrmQCmIflEKz"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Sender: riel@shelob.surriel.com
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--=-ilNaoEj4DrmQCmIflEKz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2022-05-09 at 13:09 -0700, Josh Poimboeuf wrote:


> To prevent patching, it would need to be some kind of sustained CPU
> activity, rather than a burst.=C2=A0 I guess we haven't seen that show up
> as
> a real-world problem until now.
>=20
It's amazing what you see when you have a few million very
busy servers. The problems you think of as "one in a million"
happen all the time :)

> If you're able to identify which kthreads would be problematic, then
> yeah, defining a "transition point" in their outer loops could be an
> option.
>=20
I'm in the middle of creating some scripts to gather kpatch
output from all the systems, and then sort and count the
results so we can easily see what the main pain points are.

We'll be back with patches once we have the data in hand :)


--=20
All Rights Reversed.

--=-ilNaoEj4DrmQCmIflEKz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEKR73pCCtJ5Xj3yADznnekoTE3oMFAmJ5xHQACgkQznnekoTE
3oMARAf+N4u8+luoI5PmUGF85x4q2r/nIulQtv/wREpq0T4vUkHesfPH78VUZfAg
GdYTkWEDSX4o5GRR9txs7aAoPUYy+H87YEiAWzwmmRsiuQVlu56NbqY4KK2pbspz
9BexZN15oC4yh2MEBGX/1BptB0JK0vgJNlDzzvBmXaQcBMvESgZ5A+Cg4NYCpY+u
0PQtmAaza3sKR63aNEllqwPJ9gGzE1fdnMsjDftKLIquX6ebR3Nju/yYkiNwWKup
BL4ij2MtwrbgA4Z5fLfObhxL6bi4dmyLHjM3aVWpgJuOWtphUDSgO8th8yV/9ylw
uLH+GwSAznoGRnqjYHwL85LAjqP68A==
=Mhxs
-----END PGP SIGNATURE-----

--=-ilNaoEj4DrmQCmIflEKz--
