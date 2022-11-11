Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75DDC62567B
	for <lists+live-patching@lfdr.de>; Fri, 11 Nov 2022 10:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbiKKJUs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 11 Nov 2022 04:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbiKKJUr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 11 Nov 2022 04:20:47 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339BB65E72;
        Fri, 11 Nov 2022 01:20:46 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E71C921D74;
        Fri, 11 Nov 2022 09:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1668158444; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=28YLiDWlOEKC0o04fEWJjF8Cm4n+JaA24OR0j2eMD3E=;
        b=joCt+5WdNo0YOeKjHLoR0fYk39pc5L6EFBHryUB+bMcBSQ9Q/1GdRjaQxfok4SqoqPEwMf
        f383Z4o1nvSDDOVCMt6OT1J90Qzkxhu+pSCRTCjWqwUl1pdx3zCbR59Le7l82jSzayPjhk
        +weVE1V6AnlFEH4QlzLof6pfiSg+dQA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1668158444;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=28YLiDWlOEKC0o04fEWJjF8Cm4n+JaA24OR0j2eMD3E=;
        b=qaTv2xlHKRT5OkRTMU8vNFX3fliRSZYebc0CIDxFKezksCIqO5vacrNRkrw5O9CnesdzxR
        uzj44gEDTmJOr2Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AE4FD13273;
        Fri, 11 Nov 2022 09:20:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BpJIKewTbmNcXQAAMHmgww
        (envelope-from <nstange@suse.de>); Fri, 11 Nov 2022 09:20:44 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of
 shadow variables
References: <20221026194122.11761-1-mpdesouza@suse.com>
        <20221026194122.11761-5-mpdesouza@suse.com>
        <20221104010327.wa256pos75dczt4x@treble> <Y2TooogxxLTIkBcj@alley>
Date:   Fri, 11 Nov 2022 10:20:44 +0100
In-Reply-To: <Y2TooogxxLTIkBcj@alley> (Petr Mladek's message of "Fri, 4 Nov
        2022 11:25:38 +0100")
Message-ID: <878rkhyhhv.fsf@linux.fritz.box>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi all,

Petr Mladek <pmladek@suse.com> writes:

> On Thu 2022-11-03 18:03:27, Josh Poimboeuf wrote:
>> On Wed, Oct 26, 2022 at 04:41:22PM -0300, Marcos Paulo de Souza wrote:
>> > The life of shadow variables is not completely trivial to maintain.
>> > They might be used by more livepatches and more livepatched objects.
>> > They should stay as long as there is any user.
>> >=20
>> > In practice, it requires to implement reference counting in callbacks
>> > of all users. They should register all the user and remove the shadow
>> > variables only when there is no user left.
>> >=20
>> > This patch hides the reference counting into the klp_shadow API.
>> > The counter is connected with the shadow variable @id. It requires
>> > an API to take and release the reference. The release function also
>> > calls the related dtor() when defined.
>> >=20
>> > An easy solution would be to add some get_ref()/put_ref() API.
>> > But it would need to get called from pre()/post_un() callbacks.
>> > It might be easy to forget a callback and make it wrong.
>> >=20
>> > A more safe approach is to associate the klp_shadow_type with
>> > klp_objects that use the shadow variables. The livepatch core
>> > code might then handle the reference counters on background.
>> >=20
>> > The shadow variable type might then be added into a new @shadow_types
>> > member of struct klp_object. They will get then automatically register=
ed
>> > and unregistered when the object is being livepatched. The registration
>> > increments the reference count. Unregistration decreases the reference
>> > count. All shadow variables of the given type are freed when the refer=
ence
>> > count reaches zero.
>> >=20
>> > All klp_shadow_alloc/get/free functions also checks whether the reques=
ted
>> > type is registered. It will help to catch missing registration and mig=
ht
>> > also help to catch eventual races.
>>=20
>> Is there a reason the shadow variable lifetime is tied to klp_object
>> rather than klp_patch?
>
> Good question!
>
> My thinking was that shadow variables might be tight to variables
> from a particular livepatched module. It would make sense to free them
> when the only user (livepatched module) is removed.
>
> The question is if it is really important.

I don't think so. For shadow variables attached to "real" data objects,
I would expect those objects to be gone by the time the patched ko gets
removed. For dummy shadows attached to NULL (see below), used for
handing over shared state between atomic-replace livepatch modules, the
memory footprint is negligible, I'd say.

OTOH, callbacks are per klp_object already, so for API consistency, it
might make sense to stick to this pattern for the shadows as well. But I
don't have a real opinion on this.


> I did re-read the original issue and the real problem was when the
> livepatch was reloaded.  The related variables were handled using
> livepatched code, then without the livepatched code, and then with the
> livepatched code again.
>
> The variable was modified with the original code that was not aware of
> the shadow variable. As a result the state of the shadow variable was
> not in sync when it was later used again.
>

Apologies for being late to the discussion. As I've not seen it
mentioned anywhere in this thread here -- I haven't checked v1 though --
let me outline the primary limitations (as perceived by me) of the
current shadow variables API here again, just to have it documented.


In practice, an atomic-replace klp_patch is composed of a number of
"sublivepatches" addressing individual CVEs or other issues. In general,
it is usually true that a more recent version of a livepatch contains a
superset of these sublivepatches and the individual sublivepatches'
implementations never change in practice. However, users can downgrade
an atomic-replace livepatch to an earlier version or disable a livepatch
completely.

From my experience, there are basically two relevant usage patterns of
shadow variables.
1.) To hand over global state from one sublivepatch to its pendant in
    the to-be-applied livepatch module. Example: a new global mutex or
    alike.
2.) The "regular" intended usage, attaching schadow variables to real
    (data) objects.

To manage lifetime for 1.), we usually implement some refcount scheme,
managed from the livepatches' module_init()/_exit(): the next livepatch
would subscribe to the shared state before the previous one got a chance
to release it. This works in practice, but the code related to it is
tedious to write and quite verbose.

The second usage pattern is much more difficult to implement correctly
in light of possible livepatch downgrades to a subset of
sublivepatches. Usually a sublivepatch making use of a shadow variable
attached to real objects would livepatch the associated object's
destruction code to free up the associated shadow, if any. If the next
livepatch to be applied happened to not contain this sublivepatch in
question as well, the destruction code would effectively become
unpatched, and any existing shadows leaked. Depending on the object type
in question, this memory leakage might or might not be an actual
problem, but it isn't nice either way.

Often, there's a more subtle issue with the latter usecase though: the
shadow continues to exist, but becomes unmaintained once the transitions
has started. If said sublivepatch happens to become reactivated later
on, it would potentially find stale shadows, and these could even get
wrongly associated with a completely different object which happened to
get allocated at the same memory address. Depending on the shadow type,
this might or might not be Ok. New per-object locks or a "TLB flush
needed" boolean would probably be Ok, but some kind of refcount would
certainly not. There's not much which could be done from the pre-unpatch
callbacks, because these aren't getting invoked for atomic-replace
downgrades.


We had quite some discussion internally on how to best approach these
limitations, the outcome being (IIRC), that a more versatile callbacks
support would perhaps quickly become too complex or error-prone to use
correctly. So Petr proposed this garbage collection/refcounting
mechanism posted here, which would solve the memory leakage issue as a
first step (and would make shadow variable usage less verbose IMO).

The consistency problem would still not be fully solved: consider a
refcount-like shadow, where during the transition some acquirer had been
unpatched already, while a releaser has not yet. But my hope is that we
can later build on this work here and somehow resolve this as well.


> Nicolai, your have the practical experience. Should the reference
> counting be per-livepatched object or per-livepatch, please?

See above, I think it won't matter much from a functionality POV.


>> I get the feeling the latter would be easier to implement (no reference
>> counting; also maybe can be auto-detected with THIS_MODULE?) and harder
>> for the patch author to mess up (by accidentally omitting an object
>> which uses it).
>
> I am not sure how you mean it. I guess that you suggest to store
> the name of the livepatch module into the shadow variable.
> And use the variable only when the livepatch module is still loaded.
>
> This would not help.

No, if I'm understanding correctly, this would tie the shadow lifetime
to one single livepatch module, which would make handing them over to
the next atomic-replace livepatch impossible?

>
> We use the reference counting because the shadow variables should
> survive an atomic replace of the lifepatch. In this case, the related
> variables are still handled using a livepatched code that is aware
> of the shadow variables.

Yes.


> Also it does not solve the problem that the shadow variable might
> get out of sync with the related variable when the same
> livepatch gets reloaded.

We would still not have a complete guarantee that some shadow is
consistently maintained over its full lifetime with this patchset here,
see the refcount example from above. But the overall situation would be
much better than before, IMO.

Thanks!

Nicolai

--=20
SUSE Software Solutions Germany GmbH, Frankenstra=C3=9Fe 146, 90461 N=C3=BC=
rnberg, Germany
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Boudien Moerman
(HRB 36809, AG N=C3=BCrnberg)
