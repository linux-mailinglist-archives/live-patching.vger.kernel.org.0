Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC6B673666E
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 10:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbjFTIiv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 04:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbjFTIiu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 04:38:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92944A2;
        Tue, 20 Jun 2023 01:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2sAaLrskooSi8nvsTT1gZutPHlD/k3n7r5xvvnLiOwo=; b=QBd7SbC+MJyV7/yXKjWB2RO34d
        KMb7IKnce/09nxUE59vX+DyrMq3+3ksde80hRvh74PSaSNpx9BExmPl1tT8hQDlY0RRCJd27mzHGK
        jTdeDIlO0hT18cIDPNCv2sWkLYNVbQxKO/F8FFpL0xhC5EahRo6sBAWNxNYjkiU+yZTnaeMoZDi7N
        vOQtOf6oo94YWl5q6+Gq5wOBDtAnP8PQqGVvANP8rV9pNAVKAVwt2pMg7JxVv5Aw7DqavmpWtWPaO
        CZhjIO7ekSgd79XNaCXwEwqMMGk+HQle3BUi7KXOMEMggh5H/UUpQepU1YJ5vAjCWdgbeSfwJCEPw
        SsMRkJ2g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qBWsX-00Crm5-4u; Tue, 20 Jun 2023 08:38:21 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D951F3002F0;
        Tue, 20 Jun 2023 10:38:18 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BCF1521440F49; Tue, 20 Jun 2023 10:38:18 +0200 (CEST)
Date:   Tue, 20 Jun 2023 10:38:18 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Youling Tang <tangyouling@loongson.cn>
Cc:     Xi Ruoyao <xry111@xry111.site>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        madvenka@linux.microsoft.com, chenzhongjin@huawei.com,
        WANG Xuerui <kernel@xen0n.name>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        tangyouling00@gmail.com, youling.tang@outlook.com
Subject: Re: [RFC PATCH v1 00/23] LoongArch: Add objtool and ORC unwinder
 support
Message-ID: <20230620083818.GW4253@hirez.programming.kicks-ass.net>
References: <1687247209-31676-1-git-send-email-tangyouling@loongson.cn>
 <bed4d386c16701d14a2ea395edeb0368cb3d04ad.camel@xry111.site>
 <62d25870-2caa-18ab-e58c-cee0bc383e16@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62d25870-2caa-18ab-e58c-cee0bc383e16@loongson.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jun 20, 2023 at 04:29:12PM +0800, Youling Tang wrote:
> Hi, Ruoyao
> 
> On 06/20/2023 04:15 PM, Xi Ruoyao wrote:
> > It looks like only 19 patches are successfully delivered, out of 23.
> I'm sorry, somehow the patchset didn't reach the mailing list. Probably
> due to the sending limit being reached.

I got all the patches, but their threading is broken, they come in
chunks of 5 or :/
