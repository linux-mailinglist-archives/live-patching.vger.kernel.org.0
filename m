Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE99581CCA
	for <lists+live-patching@lfdr.de>; Wed, 27 Jul 2022 02:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbiG0Aih (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 26 Jul 2022 20:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbiG0Aih (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 26 Jul 2022 20:38:37 -0400
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A85F3AB27;
        Tue, 26 Jul 2022 17:38:36 -0700 (PDT)
Received: from imladris.surriel.com ([96.67.55.152])
        by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <riel@shelob.surriel.com>)
        id 1oGUss-0001dG-Cc;
        Tue, 26 Jul 2022 20:26:42 -0400
Message-ID: <924f1cf4b93ff3e4ff217203bd88448dfa4c0f85.camel@surriel.com>
Subject: Re: [PATCH v3] livepatch: fix race between fork and
 klp_reverse_transition
From:   Rik van Riel <riel@surriel.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, kernel-team@fb.com,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Breno Leitao <leitao@debian.org>
Date:   Tue, 26 Jul 2022 20:26:41 -0400
In-Reply-To: <20220727001040.vlqnnb4a3um46746@treble>
References: <20220720121023.043738bb@imladris.surriel.com>
         <YtrCqMLUqJlcoqIo@alley> <20220722150106.683f3704@imladris.surriel.com>
         <Yt6bZo5ztnVSjLLC@alley> <20220725094919.52bcde19@imladris.surriel.com>
         <20220727001040.vlqnnb4a3um46746@treble>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-TLgTqhyEYwEQwuZaJg5g"
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


--=-TLgTqhyEYwEQwuZaJg5g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-07-26 at 17:10 -0700, Josh Poimboeuf wrote:
> On Mon, Jul 25, 2022 at 09:49:19AM -0400, Rik van Riel wrote:
> > When a KLP fails to apply, klp_reverse_transition will clear the
> > TIF_PATCH_PENDING flag on all tasks, except for newly created tasks
> > which are not on the task list yet.
>=20
> This paragraph and $SUBJECT both talk about a reverse transition.=C2=A0
> Isn't
> it also possible to race on a normal (forward) transition?

I don't know whether the race is also possible on a forward
transition.  If the parent task has transitioned, will
the child have, as well, by the time we reach the end of fork?

I suppose the only way the parent task can transition while
inside fork would be if none of the functions in its stack
need to be transitioned, and at that point the child process
would automatically be safe, too?

That would make copying the KLP transition state from parent to
child safe on a forward transition, too.

Am I overlooking anything?

However, we have only observed this warning on reverse transitions
for some reason.

> > Meanwhile, fork will copy over the TIF_PATCH_PENDING flag from the
> > parent to the child early on, in dup_task_struct ->
> > setup_thread_stack.
> >=20
> > Much later, klp_copy_process will set child->patch_state to match
> > that of the parent.
> >=20
> > However, the parent's patch_state may have been changed by KLP
> > loading
> > or unloading since it was initially copied over into the child.
> >=20
> > This results in the KLP code occasionally hitting this warning in
> > klp_complete_transition:
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for_each_process_thread(g, t=
ask) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 WARN_ON_ONCE(test_tsk_thread_flag(task,
> > TIF_PATCH_PENDING));
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 task->patch_state =3D KLP_UNDEFINED;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >=20
> > This patch will set, or clear, the TIF_PATCH_PENDING flag in the
> > child
> > process depending on whether or not it is needed at the time
> > klp_copy_process is called, at a point in copy_process where the
> > tasklist_lock is held exclusively, preventing races with the KLP
> > code.
>=20
> Use imperative language, i.e. no "This patch".=C2=A0 See
> Documentation/process/submitting-patches.rst
> >=20

Will do. I'll send a v4 tomorrow.

> > The KLP code does have a few places where the state is changed
> > without the tasklist_lock held, but those should not cause
> > problems because klp_update_patch_state(current) cannot be
> > called while the current task is in the middle of fork,
> > klp_check_and_switch_task() which is called under the pi_lock,
> > which prevents rescheduling, and manipulation of the patch
> > state of idle tasks, which do not fork.
> >=20
> > This should prevent this warning from triggering again in the
> > future.
> >=20
>=20
> Fixes: d83a7cb375ee ("livepatch: change to a per-task consistency
> model")
>=20
> > Signed-off-by: Rik van Riel <riel@surriel.com>
> > Reported-by: Breno Leitao <leitao@debian.org>
> > Reviewed-by: Petr Mladek <pmladek@suse.com>
>=20
> With the above minor things fixed:
>=20
> Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
>=20

--=20
All Rights Reversed.

--=-TLgTqhyEYwEQwuZaJg5g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEKR73pCCtJ5Xj3yADznnekoTE3oMFAmLghkEACgkQznnekoTE
3oN07ggAmmLQ3eP1Up7hCtc3DjHHadiJ4XzQx3ZAXJnyNtjj7gNdHG/F6naSSrWD
Tcqz7ArnUyaDldVKWssa4iRooRQwqdi+0IXDow4Ca1sfbvusSS3/SeofR9QcaDT7
swok1FA82hPY+Vi8LixgDILRMTw3tPVIGihlN/isPhe07LU+KxXwuIDd7pdg7qOk
NZLlGLaywOzqqHegFrW1vcwLjTq4QwEIIGDLwiJ7K4+U1r9s2hnMs0+74H3BafvD
Gznj2iOasGKTKooFof0waWEPPD+z9sBuVAPLb0RAf9Q4KlAEOdRrnjpyCAfqiw7O
mhq0eXrcvGAsIY2PvJ6j1FJ8nh7ugg==
=e8zs
-----END PGP SIGNATURE-----

--=-TLgTqhyEYwEQwuZaJg5g--
