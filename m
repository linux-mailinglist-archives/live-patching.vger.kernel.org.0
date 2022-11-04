Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7D3618D64
	for <lists+live-patching@lfdr.de>; Fri,  4 Nov 2022 02:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiKDBDj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 3 Nov 2022 21:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiKDBDb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 3 Nov 2022 21:03:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C11AF;
        Thu,  3 Nov 2022 18:03:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9D7A61FB8;
        Fri,  4 Nov 2022 01:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223C6C433C1;
        Fri,  4 Nov 2022 01:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667523809;
        bh=jRp/b9IkfrlzekzHVdtikwrza9G/ORR9jVEAya9zECA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rF3yjCYnidzl3iWr4ivImagGa6j5OH/CJjrj/67LCwlbqn9e5MFCoQZOuKlI3DrQj
         9ssTdbYUbIEhOfE5iqtKiMPvJJUbtsRUbL/oERPdpxBZ6/erRYM5bI/69khY3EpstN
         r/k+HlXpNcddKtGlvy6iOXyi0r4Fo2inQrvGxc1bqzvqWivjp1C1VRu+pXNPKiQh8w
         PxqNS3/8NYqPfmlVVs5KjfEBNp8ur4M1vcJG/4gBlHLhcczBfkSaitdSW9Keglv2/8
         Z3B6jl441nBPHAotGYTfHWUZjrTxrj+BX3IiIqheEXxE2cjM+xxEBbSaYCxFy2eSSf
         J2IAMceN5mMBg==
Date:   Thu, 3 Nov 2022 18:03:27 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Marcos Paulo de Souza <mpdesouza@suse.com>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com, pmladek@suse.com
Subject: Re: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of
 shadow variables
Message-ID: <20221104010327.wa256pos75dczt4x@treble>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-5-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221026194122.11761-5-mpdesouza@suse.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Oct 26, 2022 at 04:41:22PM -0300, Marcos Paulo de Souza wrote:
> The life of shadow variables is not completely trivial to maintain.
> They might be used by more livepatches and more livepatched objects.
> They should stay as long as there is any user.
> 
> In practice, it requires to implement reference counting in callbacks
> of all users. They should register all the user and remove the shadow
> variables only when there is no user left.
> 
> This patch hides the reference counting into the klp_shadow API.
> The counter is connected with the shadow variable @id. It requires
> an API to take and release the reference. The release function also
> calls the related dtor() when defined.
> 
> An easy solution would be to add some get_ref()/put_ref() API.
> But it would need to get called from pre()/post_un() callbacks.
> It might be easy to forget a callback and make it wrong.
> 
> A more safe approach is to associate the klp_shadow_type with
> klp_objects that use the shadow variables. The livepatch core
> code might then handle the reference counters on background.
> 
> The shadow variable type might then be added into a new @shadow_types
> member of struct klp_object. They will get then automatically registered
> and unregistered when the object is being livepatched. The registration
> increments the reference count. Unregistration decreases the reference
> count. All shadow variables of the given type are freed when the reference
> count reaches zero.
> 
> All klp_shadow_alloc/get/free functions also checks whether the requested
> type is registered. It will help to catch missing registration and might
> also help to catch eventual races.

Is there a reason the shadow variable lifetime is tied to klp_object
rather than klp_patch?

I get the feeling the latter would be easier to implement (no reference
counting; also maybe can be auto-detected with THIS_MODULE?) and harder
for the patch author to mess up (by accidentally omitting an object
which uses it).

-- 
Josh
