Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D0C58432B
	for <lists+live-patching@lfdr.de>; Thu, 28 Jul 2022 17:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiG1Phb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 28 Jul 2022 11:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiG1Ph3 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 28 Jul 2022 11:37:29 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477ED5465C;
        Thu, 28 Jul 2022 08:37:28 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 05A3C35137;
        Thu, 28 Jul 2022 15:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659022647; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PZ1g1iDmzg1vUkpBJi42fPN29v6W/qAuH8HEq7Piwls=;
        b=G9nzwH5RUiRv3tYNjRHP3cdU+Ak7QsO/RBbwasjI/2ZJfEN3zvbQzgIhQ6QS2AQEet4sCh
        lCfj/UETvZF+Vr6JrwGN2ndJvVj1feIoL4kc/fqtE1apgMhlgcazmYJ5U4QScu23PhKNUC
        DsCnK/XLGA9Vg6o9zsKdUeZdefYg3K0=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D636E2C141;
        Thu, 28 Jul 2022 15:37:26 +0000 (UTC)
Date:   Thu, 28 Jul 2022 17:37:26 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Rik van Riel <riel@surriel.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, kernel-team@fb.com,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH v4] livepatch: fix race between fork and KLP transition
Message-ID: <YuKtNtOshtRfeMn7@alley>
References: <20220720121023.043738bb@imladris.surriel.com>
 <YtrCqMLUqJlcoqIo@alley>
 <20220722150106.683f3704@imladris.surriel.com>
 <Yt6bZo5ztnVSjLLC@alley>
 <20220725094919.52bcde19@imladris.surriel.com>
 <20220727001040.vlqnnb4a3um46746@treble>
 <20220727102437.34530586@imladris.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727102437.34530586@imladris.surriel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2022-07-27 10:24:37, Rik van Riel wrote:
> v4: address changelog comments by Josh (thank you)
> 
> ---8<---
> When a KLP fails to apply, klp_reverse_transition will clear the
> TIF_PATCH_PENDING flag on all tasks, except for newly created tasks
> which are not on the task list yet.

It actually is not true. klp_reverse_transtion() clears TIF_PATCH_FLAG only
temporary when it waits until all processes leave the ftrace
handler. It sets TIF_PATCH_FLAG once again for all tasks by calling
klp_start_transition().

The difference is important. The WARN_ON_ONCE() in
klp_complete_transition() will be printed when fork() copied
TIF_PATCH_FLAG before it was set again.

Anyway, the important thing is that TIF_PATCH_FLAG and task->patch_state
might be incompatible because fork() copies them at different times.

klp_copy_process() must make sure that they are in sync. And
it must be done under tasklist_lock when the child is added
to the global task list.

Best Regards,
Petr
