Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3A258521A
	for <lists+live-patching@lfdr.de>; Fri, 29 Jul 2022 17:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236938AbiG2PJR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 29 Jul 2022 11:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236532AbiG2PJP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 29 Jul 2022 11:09:15 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37503814A7
        for <live-patching@vger.kernel.org>; Fri, 29 Jul 2022 08:09:14 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E64EA1F8B2;
        Fri, 29 Jul 2022 15:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659107352; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IUsvDQqBuRuS89Btjh/idjFid+mX+0ru2waSZ+uzYZA=;
        b=NNx2NhtLO50a0fTWflhukLzVSgQfq9pTJLSmMrlNij8HNs7vEnG/J/cG7xUbleShGEzk6Z
        lBG72zyx1/uWX00MDKDPrL0aKQJoTjNUovcOyqtxOGyFwsuE7ouKi7cJmtXEWs+GngRT1k
        TXI1TONujfia0+Kji/H6cYQ9PgQtZxs=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C5FE72C142;
        Fri, 29 Jul 2022 15:09:12 +0000 (UTC)
Date:   Fri, 29 Jul 2022 17:09:12 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Marcos Paulo de Souza <mpdesouza@suse.com>
Cc:     live-patching@vger.kernel.org, jpoimboe@redhat.com, mbenes@suse.cz,
        nstange@suse.de
Subject: Re: [PATCH 2/4] livepatch/shadow: Separate code removing all shadow
 variables for a given id
Message-ID: <YuP4GAVbMqjmLnJp@alley>
References: <20220701194817.24655-1-mpdesouza@suse.com>
 <20220701194817.24655-3-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701194817.24655-3-mpdesouza@suse.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2022-07-01 16:48:15, Marcos Paulo de Souza wrote:
> From: Petr Mladek <pmladek@suse.com>
> 
> Allow to remove all shadow variables with already taken klp_shadow_lock.
> It will be needed to synchronize this with other operation during
> the garbage collection of shadow variables.
> 
> It is a code refactoring without any functional changes.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>

It is pretty straightforward. I am not sure if it makes sense but

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
