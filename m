Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B35479687
	for <lists+live-patching@lfdr.de>; Fri, 17 Dec 2021 22:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhLQVut (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Dec 2021 16:50:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48275 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230157AbhLQVus (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Dec 2021 16:50:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639777848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rbmljmkDitEoJlRWFUe7q5wX8e3otCTyZPrRHuEzmKc=;
        b=O5KjmGIPIoMb3P6X6ZBacptn1AqfW6oVjsknAIxA1mfj0J+N0ZAuA8mroT42Q7KjmzQKmA
        +r/l75guY7Cx6tEzX/81k46ltZ6ptw7BeIJ4CyyUx2bf5mGG6OAlxc0YJMUFzFuGCt9KbW
        5d3eUTMcPRWN7yPs54xvbM97HojMPzI=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-sn3TW3adPPKITO9tV8_lgg-1; Fri, 17 Dec 2021 16:50:47 -0500
X-MC-Unique: sn3TW3adPPKITO9tV8_lgg-1
Received: by mail-qv1-f70.google.com with SMTP id t3-20020a0562140c6300b0041106ef29f2so1579256qvj.5
        for <live-patching@vger.kernel.org>; Fri, 17 Dec 2021 13:50:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rbmljmkDitEoJlRWFUe7q5wX8e3otCTyZPrRHuEzmKc=;
        b=Yo/2RGXlLWdGWVZdRTjXjXBlzXrt3h1pA9E5yITRbS1qJZrUYpjO8uj/8rIzq9lENy
         2xj8hY8OWsdUQ3R3x/oNUppleC9ns7XzaOHhmN9VcVqu0ySd2S0ul9syOSagc+YTLdii
         CP32k98grGj5hgLSKtx1ctoXRsM3QoRmSNu6jbm8iX76gLiEjiEGEZ3DtUQQvMlTYt8D
         JYxcvB36BV9cvEavhIxJb07J3f0E0iJYImCXYc0Cu4EBnr2fGaFCDobSoL/byWHy9jKF
         Yzw1FmLUO9B4NghyAQY6qMV4hKW6hf7le+V1zg3fqbnyFKmfodiGiIcuuRiS3zMqU0pw
         NJGQ==
X-Gm-Message-State: AOAM530xarE1Xj9HXsY3njbJUTS1z6aa1ptH7d+cyvKeV0JL3RTebtCe
        punpeBGuoCrJAlWG8ZBhPufxikYPmLLsnqHpNB9t4Gw/p6jbLrEhRG4sYIounzme3VtP2NR242x
        Ah3Y+GTXGH3UTNee0mqKLZrHcOw==
X-Received: by 2002:a05:620a:2848:: with SMTP id h8mr3225253qkp.270.1639777846765;
        Fri, 17 Dec 2021 13:50:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx3jLcgYHEzsebMSk9tVxU2ahYLfPrYelvOzO6K5TPcHFZb+5pTnbauFLDR9slrasqJ/kdXXQ==
X-Received: by 2002:a05:620a:2848:: with SMTP id h8mr3225241qkp.270.1639777846461;
        Fri, 17 Dec 2021 13:50:46 -0800 (PST)
Received: from treble ([2600:1700:6e32:6c00::45])
        by smtp.gmail.com with ESMTPSA id bk39sm5577802qkb.35.2021.12.17.13.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 13:50:45 -0800 (PST)
Date:   Fri, 17 Dec 2021 13:50:42 -0800
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     David Vernet <void@manifault.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, corbet@lwn.net, songliubraving@fb.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v2] livepatch: Fix leak on klp_init_patch_early failure
 path
Message-ID: <20211217215042.76m5qn5e63ptgrjq@treble>
References: <20211214220124.2911264-1-void@manifault.com>
 <20211214235128.ckaozqsvcr6iqcnu@treble>
 <Ybm+FyhLnuH4JThq@alley>
 <YboHpHmu3D+0hxKp@dev0025.ash9.facebook.com>
 <YbyV7nsLXbQ6/44S@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YbyV7nsLXbQ6/44S@alley>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Dec 17, 2021 at 02:51:42PM +0100, Petr Mladek wrote:
> On Wed 2021-12-15 07:20:04, David Vernet wrote:
> > Petr Mladek <pmladek@suse.com> wrote on Wed [2021-Dec-15 11:06:15 +0100]:
> > > Well, I still believe that this is just a cargo cult. And I would prefer
> > > to finish the discussion about it, first, see
> > > https://lore.kernel.org/all/YbmlL0ZyfSuek9OB@alley/
> > 
> > No problem, I won't send out v3 until we've finished the discussion and
> > have consensus. I'll assume that the discussion on whether or not there is
> > a leak will continue on the thread you linked to above, so I won't comment
> > on it here.
> > 
> > > Note that klp_init_*_early() functions iterate through the arrays
> > > using klp_for_each_*_static. While klp_free_*() functions iterate
> > > via the lists using klp_for_each_*_safe().
> > 
> > Correct, as I've understood it, klp_for_each_*_safe() should only iterate
> > over the objects that have been added to the patch and klp_object's lists,
> > and thus for which kobject_init() has been invoked. So if we fail a check
> > on 'struct klp_object' N, then we'll only iterate over the first N - 1
> > objects in klp_for_each_*_safe().
> > 
> > > We should not need the pre-early-init check when the lists include only
> > > structures with initialized kobjects.
> > 
> > Not sure I quite follow. We have to do NULL checks for obj->funcs at some
> > point, and per Josh's suggestion it seems cleaner to do it outside the
> > critical section, and before we actually invoke kobject_init(). Apologies
> > if I've misunderstood your point.
> 
> The original purpose of klp_init_*_early() was to allow calling
> klp_free_patch_*() when klp_init_*() fails. The idea was to
> initialize all fields properly so that free functions would
> do the right thing.
> 
> Josh's proposal adds pre-early-init() to allow calling
> klp_free_patch_*() already when klp_init_*_early() fails.
> The purpose is to make sure that klp_init_*_early()
> will actually never fail.
> 
> This might make things somehow complicated. Any future change
> in klp_init_*_early() might require change in pre-early-init()
> to catch eventual problems earlier.

I'm not sure why that would be a problem.  If we can separate out the
things which fail from the things which don't, it simplifies things.

And if klp_init_object_early() returns void then it would make sense for
klp_init_patch_early() to also return void.

> Also I am not sure what to do with the existing checks
> in klp_init_patch_early(). I am uneasy with removing them
> and hoping that pre-early-init() did the right job.

klp_init_patch_early() already depends on some of the other checks in
klp_enable_patch() anyway.  I don't see that as much of a problem since
it only has one caller.

The benefit of moving the rest of the checks out is that it simplifies
the error handling, with no possibility of half-baked structures.

> But if we keep the checks then klp_init_patch_early() then it
> might fail and the code will not be ready for this.
> 
> 
> My proposal is to use simple trick. klp_free_patch_*() iterate
> using the dynamic list (list_for_each_entry) while klp_init_*_early()
> iterate using the arrays.
> 
> Now, we just need to make sure that klp_init_*_early() will only add
> fully initialized structures into the dynamic list. As a result,
> klp_free_patch() will see only the fully initialized structures
> and could release them. It will not see that not-yet-initialized
> structures but it is fine. They are not initialized and they do not
> need to be freed.
> 
> In fact, I think that klp_init_*_early() functions already do
> the right thing. IMHO, if you move the module_get() then you
> could safely do:
> 
> int klp_enable_patch(struct klp_patch *patch)
> {
> [...]
> 	if (!try_module_get(patch->mod)) {
> 		mutex_unlock(&klp_mutex);
> 		return -ENODEV;
> 	}
> 
> 	ret = klp_init_patch_early(patch);
> 	if (ret)
> 		goto err;
> 
> 
> Note that it would need to get tested.
> 
> Anyway, does it make sense now?

It would work, but it's too clever/non-obvious.  If we rely on tricks
then we may eventually forget about them and accidentally break
assumptions later.

-- 
Josh

