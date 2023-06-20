Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D47736687
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 10:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbjFTIm3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 04:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjFTIm2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 04:42:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DC8E72;
        Tue, 20 Jun 2023 01:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dTUrblKTbzN6amETH1sEq8bWsOnIFEMvmYAlb38sQ3Q=; b=W4iZsvICabFW9ej9X7BmjFVSV/
        b5ivy4Fk6DHKezLH2bN7IrZpviCv/r1MgCxxm7JV0bAtszNt7y2Fih7BsdFfZHDULIYwT8qGOlCHc
        5grXJiYL15PMLk9diPLPXJ93192mmdeWK75mUCYwU41v6c/rDWHjZ4cIAvTKqFL1k5F/+I3uKzTq6
        M5XO6ag1qpHlWbFDAqlOcaWEkRuYADjPuYFIzTgQ4sQKRzKPgDN/N3ZsIf+0c5+LE9Q6uBD7817h5
        F8qP1gPD7PXEpiqPUJDzAieol0mp0BQG+SI9gw/Nxzbt7KNQo5JaQGB+KfCt6Yv3iWdIaPmV0fBLn
        mVeOlOPQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qBWwF-00Crzs-BE; Tue, 20 Jun 2023 08:42:11 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id EA48730020B;
        Tue, 20 Jun 2023 10:42:10 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C531621440F49; Tue, 20 Jun 2023 10:42:10 +0200 (CEST)
Date:   Tue, 20 Jun 2023 10:42:10 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Youling Tang <tangyouling@loongson.cn>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        madvenka@linux.microsoft.com, chenzhongjin@huawei.com,
        WANG Xuerui <kernel@xen0n.name>,
        Xi Ruoyao <xry111@xry111.site>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        tangyouling00@gmail.com, youling.tang@outlook.com
Subject: Re: [RFC PATCH v1 00/23] LoongArch: Add objtool and ORC unwinder
 support
Message-ID: <20230620084210.GX4253@hirez.programming.kicks-ass.net>
References: <1687247209-31676-1-git-send-email-tangyouling@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1687247209-31676-1-git-send-email-tangyouling@loongson.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jun 20, 2023 at 03:46:26PM +0800, Youling Tang wrote:
> This series of patches adds objtool and ORC unwinder support for
> LoongArch.
> 
> Patch 01 - 07 are from "Madhavan T. Venkataraman" [1] with minor
> code tweaks. The "objtool: Reorganize ORC types" patch was not
> added, because LoongArch cannot share `strcut orc_entry`, it also
> needs to include ra_offset and ra_reg.

Yeah, I wish you would not have done that :-( I really don't like those
patches. I just don't much believe in that dynamic validation thing, and
doubly not for the patches you did pick not including any actual
rationale for it.


Also, the patches very much do not apply to tip/objtool/core,
specifically Josh recently reworked the reloc stuff quite dramatically.
