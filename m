Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6FB5882EC
	for <lists+live-patching@lfdr.de>; Tue,  2 Aug 2022 22:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiHBUHT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Aug 2022 16:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbiHBUHQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Aug 2022 16:07:16 -0400
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEFB52455;
        Tue,  2 Aug 2022 13:07:13 -0700 (PDT)
Received: from imladris.surriel.com ([96.67.55.152])
        by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <riel@shelob.surriel.com>)
        id 1oIyAX-0004rB-GU;
        Tue, 02 Aug 2022 16:07:09 -0400
Message-ID: <c04f97fc29c4618f137b27ce6537800b53f1d95f.camel@surriel.com>
Subject: Re: [PATCH v4] livepatch: fix race between fork and KLP transition
From:   Rik van Riel <riel@surriel.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, kernel-team@fb.com,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Breno Leitao <leitao@debian.org>
Date:   Tue, 02 Aug 2022 16:07:08 -0400
In-Reply-To: <YuKtNtOshtRfeMn7@alley>
References: <20220720121023.043738bb@imladris.surriel.com>
         <YtrCqMLUqJlcoqIo@alley> <20220722150106.683f3704@imladris.surriel.com>
         <Yt6bZo5ztnVSjLLC@alley> <20220725094919.52bcde19@imladris.surriel.com>
         <20220727001040.vlqnnb4a3um46746@treble>
         <20220727102437.34530586@imladris.surriel.com> <YuKtNtOshtRfeMn7@alley>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Nxd+hE9FVti54GnCAJoi"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Sender: riel@shelob.surriel.com
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--=-Nxd+hE9FVti54GnCAJoi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2022-07-28 at 17:37 +0200, Petr Mladek wrote:
> On Wed 2022-07-27 10:24:37, Rik van Riel wrote:
> > v4: address changelog comments by Josh (thank you)
> >=20
> > ---8<---
> > When a KLP fails to apply, klp_reverse_transition will clear the
> > TIF_PATCH_PENDING flag on all tasks, except for newly created tasks
> > which are not on the task list yet.
>=20
> It actually is not true. klp_reverse_transtion() clears
> TIF_PATCH_FLAG only
> temporary when it waits until all processes leave the ftrace
> handler. It sets TIF_PATCH_FLAG once again for all tasks by calling
> klp_start_transition().
>=20
> The difference is important. The WARN_ON_ONCE() in
> klp_complete_transition() will be printed when fork() copied
> TIF_PATCH_FLAG before it was set again.
>=20
> Anyway, the important thing is that TIF_PATCH_FLAG and task-
> >patch_state
> might be incompatible because fork() copies them at different times.
>=20
> klp_copy_process() must make sure that they are in sync. And
> it must be done under tasklist_lock when the child is added
> to the global task list.

Hmmm, how should this be addressed in the changelog?

Should I just remove most of that paragraph and leave it
at "there can be a race"?

--=20
All Rights Reversed.

--=-Nxd+hE9FVti54GnCAJoi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEKR73pCCtJ5Xj3yADznnekoTE3oMFAmLpg+wACgkQznnekoTE
3oOMtgf+LICxfgyqVJ5HbLR1scHDM52cOhY6iQn3+3HRlav6AcHmXP1sAtyYZ0PN
Bl/FkDDU/fRNwEREnnaIID/2yzcIi5zeX4bdUDjDMDfsVPm9E83nnGkovX0Ej12W
G0CCkq1tixNY4LRaiLe1E/+uYyrEsqVVWCi4e6pQOriFE8wH66qwQWenfdIFQfVS
tDvnzSN4AgegaljE1CDN4Yox6E6gpCcDr0nq5obw4v74uv5kTp0k5mfZHFTk5jod
EPLF2q50ZOHgOYAMhESCpAky3JDzaxdtFjhLiSqeTYjH7StsUYef8d+EGlA7xMtW
d9yJu19Cgyj8qg/7RBpDBsQzlqSZ3g==
=HRe+
-----END PGP SIGNATURE-----

--=-Nxd+hE9FVti54GnCAJoi--
