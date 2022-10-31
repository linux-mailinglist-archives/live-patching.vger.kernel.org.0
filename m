Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1BE613A96
	for <lists+live-patching@lfdr.de>; Mon, 31 Oct 2022 16:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbiJaPqB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 31 Oct 2022 11:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbiJaPpj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 31 Oct 2022 11:45:39 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59ADB12A86;
        Mon, 31 Oct 2022 08:44:52 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 10DFC338D0;
        Mon, 31 Oct 2022 15:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1667231091; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i4Zj+h04eVlfP46QU5vTbodNu6q3W8ewMemZyhjhMOU=;
        b=JVz+ccZ3uUe8BmOeu0DTtJw8zaRAEqp6azs2ERt8mYicgfeBVM5qA6sPY/6USr6PWVQE9x
        jcbPlx7zZOWcDyeuKpfm1QPK50p6uGIY8rw2lk+GZv9lqOoiaOt+Kz8WQR9giTQD6haSmq
        Gr3Du5UUMECLqvBNEULmhlUbHoajGKA=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D77602C141;
        Mon, 31 Oct 2022 15:44:50 +0000 (UTC)
Date:   Mon, 31 Oct 2022 16:44:49 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Marcos Paulo de Souza <mpdesouza@suse.com>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 1/4] livepatch/shadow: Separate code to get or use
 pre-allocated shadow variable
Message-ID: <Y1/tcTPpebM/2y46@alley>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-2-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026194122.11761-2-mpdesouza@suse.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2022-10-26 16:41:19, Marcos Paulo de Souza wrote:
> From: Petr Mladek <pmladek@suse.com>
> 
> Separate code that is used in klp_shadow_get_or_alloc() under klp_mutex.
> It splits a long spaghetti function into two. Also it unifies the error
> handling. The old used a mix of duplicated code, direct returns,
> and goto. The new code has only one unlock, free, and return calls.
> 
> It is code refactoring without any functional changes.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
