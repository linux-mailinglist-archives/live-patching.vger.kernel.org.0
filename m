Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0853B62061D
	for <lists+live-patching@lfdr.de>; Tue,  8 Nov 2022 02:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbiKHBda (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 7 Nov 2022 20:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbiKHBdO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 7 Nov 2022 20:33:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBA111A;
        Mon,  7 Nov 2022 17:32:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A176B61374;
        Tue,  8 Nov 2022 01:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC968C433C1;
        Tue,  8 Nov 2022 01:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667871131;
        bh=ED313/aaAI+lz49lB29Wmv20Z3nVuXhp1WXomGj7JMo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YAIosAcx5ddEnbPE5VGv5y5o955A5t4+cQY/gyHGTJb2+jU4Xgk+ldbnQy+yCjVaE
         5krArbp38G8pflcWUNemKsugI8PO9LdPYSMuz/+Gd2lSj/GfKQOto9bx8iq7j+JKXa
         OYcGdSVe75nEOCI9UPNjwTNostb54PggF6ZUx9KclSfFXkad654d4ClVdjGkXMtnVU
         jAGODql/ITbX5DrOVIRUYhciEP8BAqxrg3vGFSgEgJ7yPtcxORm+uh+sQG+3doZiiN
         vQyXK/4Vap7NgMgsZiVAxqDFlJPezuHWO8ewYH+0ERYeRjdNRdR5QYqCBWqVhUwVYd
         Mazsa0qZjMX2A==
Date:   Mon, 7 Nov 2022 17:32:09 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Nicolai Stange <nstange@suse.de>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of
 shadow variables
Message-ID: <20221108013209.eqrxs3xqtat6kksm@treble>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-5-mpdesouza@suse.com>
 <20221104010327.wa256pos75dczt4x@treble>
 <Y2TooogxxLTIkBcj@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y2TooogxxLTIkBcj@alley>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Nov 04, 2022 at 11:25:38AM +0100, Petr Mladek wrote:
> > I get the feeling the latter would be easier to implement (no reference
> > counting; also maybe can be auto-detected with THIS_MODULE?) and harder
> > for the patch author to mess up (by accidentally omitting an object
> > which uses it).
> 
> I am not sure how you mean it. I guess that you suggest to store
> the name of the livepatch module into the shadow variable.
> And use the variable only when the livepatch module is still loaded.

Actually I was thinking the klp_patch could have references to all the
shadow variables (or shadow variable types?) it owns.

Instead of reference counting, the livepatch atomic replace code could
just migrate any previously owned shadow variables to the new klp_patch.

This of course adds the restriction that such garbage-collected shadow
variables couldn't be shared across non-replace livepatches.  But I
wouldn't expect that to be much of a problem.

Additionally, I was wondering if "which klp_patch owns which shadow
variables" could be auto-detected somehow.

For example:

1) add 'struct module *owner' or 'struct klp_patch *owner' to klp_shadow

2) add klp_shadow_alloc_gc() and klp_shadow_get_or_alloc_gc(), which are
   similar to their non-gc counterparts, with a few additional
   arguments: the klp module owner (THIS_MODULE for the caller); and a
   destructor to be used later for the garbage collection

3) When atomic replacing a patch, iterate through the klp_shadow_hash
   and, for each klp_shadow which previously had an owner, change it to
   be owned by the new patch

4) When unloading/freeing a patch, free all its associated klp_shadows
   (also calling destructors where applicable)


I'm thinking this would be easier for the patch author, and also simpler
overall.  I could work up a patch.

-- 
Josh
