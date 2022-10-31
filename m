Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF3CB613AEF
	for <lists+live-patching@lfdr.de>; Mon, 31 Oct 2022 17:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiJaQCw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 31 Oct 2022 12:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiJaQCv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 31 Oct 2022 12:02:51 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DB41261E;
        Mon, 31 Oct 2022 09:02:49 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A5C9A1F8BF;
        Mon, 31 Oct 2022 16:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1667232168; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5f0KAVsFXb/ej/un0lRY1Csig49umoppXqYjY155Z6g=;
        b=eZsV82B+J19cWmH9zItt2iMfa9634CyuWIIGXCQaxVv/7DIedpBQ9a2pbA6Vte67mdjjDM
        ofz02mVR7oIkhDVTyai57snwO48I4si2YtrlXCYJvSz2S2MR4ItCZoTTSvOZa0c1yWW/Zl
        ZZJ1KZTiYMrMlER9BMd24A1Kmljs+X8=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 766DD2C141;
        Mon, 31 Oct 2022 16:02:48 +0000 (UTC)
Date:   Mon, 31 Oct 2022 17:02:47 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Marcos Paulo de Souza <mpdesouza@suse.com>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 3/4] livepatch/shadow: Introduce klp_shadow_type
 structure
Message-ID: <Y1/xp7OBgu3qGUKz@alley>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-4-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026194122.11761-4-mpdesouza@suse.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2022-10-26 16:41:21, Marcos Paulo de Souza wrote:
> The shadow variable type will be used in klp_shadow_alloc/get/free
> functions instead of id/ctor/dtor parameters. As a result, all callers
> use the same callbacks consistently[*][**].
> 
> The structure will be used in the next patch that will manage the
> lifetime of shadow variables and execute garbage collection automatically.
> 
> [*] From the user POV, it might have been easier to pass $id instead
>     of pointer to struct klp_shadow_type.
> 
>     It would require registering the klp_shadow_type so that
>     the klp_shadow API could find ctor/dtor for the given id.
>     It actually will be needed for the garbage collection anyway
>     because it will define the lifetime of the variables.
> 
>     The bigger problem is that the same klp_shadow_type might be
>     used by more livepatch modules. Each livepatch module need
>     to duplicate the definition of klp_shadow_type and ctor/dtor
>     callbacks. The klp_shadow API would need to choose one registered
>     copy.
> 
>     The definitions should be compatible and they should stay as long
>     as the type is registered. But it still feels more safe when
>     klp_shadow API callers use struct klp_shadow_type and ctor/dtor
>     callbacks defined in the same livepatch module.
> 
>     This problem is gone when each livepatch explicitly uses its
>     own struct klp_shadow_type pointing to its own callbacks.

This paragraph seems redundant. It more or less repeats what
is said in the previous one.


> [**] test_klp_shadow_vars.c uses a custom @dtor to show that it was called.
>     The message must be disabled when called via klp_shadow_free_all()
>     because the ordering of freed variables is not well defined there.
>     It has to be done using another hack after switching to
>     klp_shadow_types.
> 
> Co-developed-by: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>

I am never sure how the co-authoring should be done ;-) But I believe
that the author should always be the first one. And the other author
should be listed either by Co-developer-by: or by Signed-off-by: but
not by both tags. So, it should be:

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Co-developed-by: Petr Mladek <pmladek@suse.com>


With the removed paragraph and updated tags:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr


PS: No need to resend the patch. I could do the two changes
    when pushing it.
