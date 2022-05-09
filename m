Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E22B520579
	for <lists+live-patching@lfdr.de>; Mon,  9 May 2022 21:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240680AbiEITx4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 9 May 2022 15:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240677AbiEITxz (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 9 May 2022 15:53:55 -0400
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F5D18E877;
        Mon,  9 May 2022 12:49:59 -0700 (PDT)
Received: from imladris.surriel.com ([96.67.55.152])
        by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <riel@shelob.surriel.com>)
        id 1no9OD-0005ca-8v; Mon, 09 May 2022 15:49:53 -0400
Message-ID: <1f94c48b4e0e7d73a689a076f78f0892095b4d89.camel@surriel.com>
Subject: Re: [RFC] sched,livepatch: call stop_one_cpu in
 klp_check_and_switch_task
From:   Rik van Riel <riel@surriel.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Song Liu <song@kernel.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, mingo@redhat.com,
        peterz@infradead.org, vincent.guittot@linaro.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com, kernel-team@fb.com
Date:   Mon, 09 May 2022 15:49:52 -0400
In-Reply-To: <20220509191745.yk2txsa4cv3ypf6k@treble>
References: <20220507174628.2086373-1-song@kernel.org>
         <20220509115227.6075105e@imladris.surriel.com>
         <20220509180004.zmvhz65xlncwqrrc@treble>
         <68f91fb233d5bf82e29cc5c6960a62863b297db3.camel@surriel.com>
         <20220509191745.yk2txsa4cv3ypf6k@treble>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-/zMvygGJfLAsI+n3XX7/"
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


--=-/zMvygGJfLAsI+n3XX7/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2022-05-09 at 12:17 -0700, Josh Poimboeuf wrote:
> On Mon, May 09, 2022 at 03:10:16PM -0400, Rik van Riel wrote:
>=20
>=20
> > Should kernel threads that can use a lot of CPU have
> > something in their outer loop to transition KLPs,
> > just like the idle task does?
>=20
> Maybe - I suppose this is the first time we've had an issue with
> CPU-bound kthreads.=C2=A0 I didn't know that was a thing ;-)
>=20
Kworkers have as much work as you want them to do, and with
things like btrfs compression that can be quite a bit.

--=20
All Rights Reversed.

--=-/zMvygGJfLAsI+n3XX7/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEKR73pCCtJ5Xj3yADznnekoTE3oMFAmJ5cGAACgkQznnekoTE
3oN/vwgAlL+sgfIYzv4Yn8QkvhM+LGFufW9bo9fyeDXE4x1pZZ2Z2k7H6JrQwUee
fF4fCr+u6d7m5KS3ZhYjbYNEWsmTfDJusHOxn9EExSruLpHZwKVNDeJxBngD1agc
vb3cj6qTPNiEtv6bxPF0HLCbaGyUSZ52pR7bv/KrcXlykAvCFZ49F5cebludpcGN
Qe43vPoOouEksejhUceSzCHd9ja1Lb03xif5hvRO7/JyOQX8Sx6/FgNEeltTfwiR
a8SPD8k51Uaq7d6y6saT+BPmCHa09KEBDi+SQqfDkwW9fn8IIZMtTJtmSNdJ7c3N
/vqwM04dbcYoV9kmAlzx2OZNFsiOnQ==
=MMoT
-----END PGP SIGNATURE-----

--=-/zMvygGJfLAsI+n3XX7/--
