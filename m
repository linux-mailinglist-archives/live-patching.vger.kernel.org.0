Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4FB5F05CD
	for <lists+live-patching@lfdr.de>; Fri, 30 Sep 2022 09:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiI3Hhj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 30 Sep 2022 03:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiI3Hhi (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 30 Sep 2022 03:37:38 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE9717F57B;
        Fri, 30 Sep 2022 00:37:36 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 71DF61F8C5;
        Fri, 30 Sep 2022 07:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664523454; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4eHJc3tsRvKBQVsLMvLqCmUK7/D5zJMrXa24JNW5PuQ=;
        b=MTiI7reU4pPvjP/X77XGOveBIjxPDSiwtr8mB0apENbWwaiiYw88wGCHxYFYYgf+b2DEu1
        KamfkF5tbsI+6Gg+g3VLtU7uSrNECCZP8UGg+zazMrPY0i/I1oryf832JTXJOLPbhhx7oI
        Bfth1mZ7W6ZoEBTJbBLNClsBFM3p/6I=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 529392C15D;
        Fri, 30 Sep 2022 07:37:34 +0000 (UTC)
Date:   Fri, 30 Sep 2022 09:37:33 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: Move the result-invariant calculation out of
 the loop
Message-ID: <YzacvcSOoICzYtx8@alley>
References: <20220930015446.1270-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930015446.1270-1-thunder.leizhen@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2022-09-30 09:54:46, Zhen Lei wrote:
> The calculation results of the variables 'func_addr' and 'func_size' are
> not affected by the for loop and do not change due to the changes of
> entries[i]. The performance can be improved by moving it outside the loop.
> 
> No functional change.
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>

Makes sense:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
