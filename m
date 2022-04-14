Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 191775008BE
	for <lists+live-patching@lfdr.de>; Thu, 14 Apr 2022 10:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240955AbiDNIxJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Apr 2022 04:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241153AbiDNIwu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Apr 2022 04:52:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA8E3ED35;
        Thu, 14 Apr 2022 01:50:26 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 9B7461F746;
        Thu, 14 Apr 2022 08:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649926225; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XxfuG/w8wazXndKDtI84HuuhaGnd2O75E0snozQKqmw=;
        b=iz08PdaSiF0q8xS9gHtDXbKt2+Cg2/r7HqDgFIICsQQiDZILaWd0JJv5xY+B7tkb8baXaj
        d/g4alheoIDrplBYmTpAMVYwdxU4se5s9Lg/RqnKsPM6gHipvoqrCizQoFCzlTSnKSUakj
        bSSd1i86UcwPu8DuSbq1h6F4shixvBs=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7AB43A3B88;
        Thu, 14 Apr 2022 08:50:25 +0000 (UTC)
Date:   Thu, 14 Apr 2022 10:50:24 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [RFC PATCH v6 01/12] livepatch: Create and include UAPI headers
Message-ID: <YlfgUNDQsYw8+ksC@alley>
References: <20220216163940.228309-1-joe.lawrence@redhat.com>
 <20220216163940.228309-2-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216163940.228309-2-joe.lawrence@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2022-02-16 11:39:29, Joe Lawrence wrote:
> From: Josh Poimboeuf <jpoimboe@redhat.com>
> 
> Define klp prefixes in include/uapi/linux/livepatch.h, and use them for
> replacing hard-coded values in kernel/livepatch/core.c.
> 
> Update MAINTAINERS.
> 
> Note: Add defines to uapi as these are also to be used by a newly
> introduced klp-convert script.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Joao Moreira <jmoreira@suse.de>
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>

Looks straightforward:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
