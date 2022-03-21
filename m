Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B154E276E
	for <lists+live-patching@lfdr.de>; Mon, 21 Mar 2022 14:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244257AbiCUNZg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 21 Mar 2022 09:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240433AbiCUNZf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 21 Mar 2022 09:25:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8D84DF6C;
        Mon, 21 Mar 2022 06:24:10 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 327BD1F37C;
        Mon, 21 Mar 2022 13:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647869049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E7U5uKaIQLUvkNLhP5oQgV7mc1DnEGBbOz9yuTiVwsc=;
        b=lLqP4nm6FvptzyZodFT83i+DUtjxZfsnYChrSh44AqUSurAS1CaHpsnPVSJPEKKRNsGut5
        hmfHDG4J34S2R3N8MbMaZFgF4TXK6tB1pzwVILSkEt9oXGXsiKdnZZAJ6TF4SFk/Jwj2eq
        hz5E+vzeNQyD8sY6Te9uTg2tQYOr44w=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 12740A3B81;
        Mon, 21 Mar 2022 13:24:09 +0000 (UTC)
Date:   Mon, 21 Mar 2022 14:24:05 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     trix@redhat.com
Cc:     jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, nathan@kernel.org,
        ndesaulniers@google.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v2] livepatch: Reorder to use before freeing a pointer
Message-ID: <Yjh8dX1iMsHUF4nU@alley>
References: <20220320015143.2208591-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220320015143.2208591-1-trix@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat 2022-03-19 18:51:43, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Clang static analysis reports this issue
> livepatch-shadow-fix1.c:113:2: warning: Use of
>   memory after it is freed
>   pr_info("%s: dummy @ %p, prevented leak @ %p\n",
>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> The pointer is freed in the previous statement.
> Reorder the pr_info to report before the free.
> 
> Similar issue in livepatch-shadow-fix2.c
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Strictly speaking, the freed memory is not used.
pr_info() only prints the address.

Anyway, I agree that the reordered code is cleaner.

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
