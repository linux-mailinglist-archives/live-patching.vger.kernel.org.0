Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7FBB4F949E
	for <lists+live-patching@lfdr.de>; Fri,  8 Apr 2022 13:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbiDHL4v (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 8 Apr 2022 07:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiDHL4r (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 8 Apr 2022 07:56:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD661277C;
        Fri,  8 Apr 2022 04:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=r6xoh+05MXLt0QBstExind4qaMc5VJx23F738tTh/mk=; b=ucP2XW6917m0BiNvodtnR12Fjy
        IOmSZZ+rVHERCqC8XJtt3yfByaEAmXQru4/jjVA14LuRNVUVa3i+AIXU/8/T2a/SNdZScOddbKq7g
        gf1vEUH2K12q7GLb0mnkaCr4YNt6TZOIRX3JU3PrHSOp+dKs/AxmaKHhWW6lgiZJ439lF2/iohl0q
        R39DE6AMiHB9BRCc2/4uyiRnF0Y8XR2poZy5+WJsjiAi3I/bK3Vj+Cy2SaCoKgcf/sEt+3UQNJ4SN
        dj0yqbHobseQF98XJNxqXUCQzD1k5Wir6LEIKkIBSHYvLZLNorrg/pKgps9N8TvzQ1wAh+HD8A92F
        rRxULz6Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ncnCA-009mn4-VH; Fri, 08 Apr 2022 11:54:31 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 197B03000E6;
        Fri,  8 Apr 2022 13:54:28 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CDC66302DDE0D; Fri,  8 Apr 2022 13:54:28 +0200 (CEST)
Date:   Fri, 8 Apr 2022 13:54:28 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/9] arm64: livepatch: Use DWARF Call Frame
 Information for frame pointer validation
Message-ID: <YlAidG0qYe+yh/vg@hirez.programming.kicks-ass.net>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
 <YlAUj6w6fePEo7v+@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlAUj6w6fePEo7v+@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Apr 08, 2022 at 12:55:11PM +0200, Peter Zijlstra wrote:
> On Thu, Apr 07, 2022 at 03:25:09PM -0500, madvenka@linux.microsoft.com wrote:
> 
> > [-- application/octet-stream is unsupported (use 'v' to view this part) --]
> 
> Your emails are unreadable :-(

List copy is OK, so perhaps it's due to how Josh bounced them..
