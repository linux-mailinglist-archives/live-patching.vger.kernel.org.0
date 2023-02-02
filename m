Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F7F6879E6
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 11:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjBBKOT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 05:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjBBKOS (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 05:14:18 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D4E4486;
        Thu,  2 Feb 2023 02:14:17 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 56BF82276E;
        Thu,  2 Feb 2023 10:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675332856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p31X8rg6IQRCHX5i7Rkmpa8W9WOMg1X/uai0p+zsV5o=;
        b=g7jdrYvXmTXtR5hqyEx/b3kpDxBwHc9+zKAmn6uojCnq1tlR80EfLXBdQzgj8a1K8VyclL
        wqWru85o9xWJ170f2zAaPxl8VAbh8Is6MbETG2D9PjieQH6r5LyAc9IQILuoLg7aoE9eW2
        hwxoX3L4uqy00MMqeQMrsZb9aBDCOLc=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 0D2F32C141;
        Thu,  2 Feb 2023 10:14:16 +0000 (UTC)
Date:   Thu, 2 Feb 2023 11:14:15 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of
 shadow variables
Message-ID: <Y9uM94UOJWcNxnkI@alley>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-5-mpdesouza@suse.com>
 <20230201001817.ej7n3ehtgaxwr3pq@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201001817.ej7n3ehtgaxwr3pq@treble>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2023-01-31 16:18:17, Josh Poimboeuf wrote:
> On Wed, Oct 26, 2022 at 04:41:22PM -0300, Marcos Paulo de Souza wrote:
> > The shadow variable type might then be added into a new @shadow_types
> > member of struct klp_object. They will get then automatically registered
> > and unregistered when the object is being livepatched. The registration
> > increments the reference count. Unregistration decreases the reference
> > count. All shadow variables of the given type are freed when the reference
> > count reaches zero.
> 
> How does the automatic unregistration work for replaced patches?
> 
> I see klp_unpatch_replaced_patches() is called, but I don't see where it
> ends up calling klp_shadow_unregister() for the replaced patch(es).

Great catch! I forgot that replaced patches are handled separately.
We should do the following (on top of this patch):

--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -123,8 +123,11 @@ static void klp_complete_transition(void)
 			continue;
 		if (klp_target_state == KLP_PATCHED)
 			klp_post_patch_callback(obj);
-		else if (klp_target_state == KLP_UNPATCHED) {
+		else if (klp_target_state == KLP_UNPATCHED)
 			klp_post_unpatch_callback(obj);
+
+		if (klp_target_state == KLP_UNPATCHED ||
+		    klp_transition_patch->replace) {
 			klp_unregister_shadow_types(obj);
 		}
 	}


Also we should add more selftests for handling the shadow variables.

Best Regards,
Petr
