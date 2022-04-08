Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F84A4F935B
	for <lists+live-patching@lfdr.de>; Fri,  8 Apr 2022 12:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbiDHK5e (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 8 Apr 2022 06:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234812AbiDHK5d (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 8 Apr 2022 06:57:33 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28A367D3B;
        Fri,  8 Apr 2022 03:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=V7XARVkxVEpP6+e9b+MZ/qn1EGzHHLuhmqLrgehi0U0=; b=SAZDKQlqH2h7qnCCjba0ThjGt2
        0GyQ7vgQvYLBz9FkHZi1EfqKcl/gAgnzxEqJCy5zXBlOlphJQ1vb3a7Oxx8MBsCBNSS6jflXU9EaW
        AVxR6YUUYOX5Yhnl9CLnW0NYX//mycjfSz4zO0EgOX8Zj2SKc3pdvUjISyxKtu6nCYvWxql2y7Qc1
        HJtXJLnps6uaR7nmmLhwHnFNleqvkEvTPOqb56R2zp42VUj7T4pogYx2xHV+IJIKjXPqAE+Vn2ZBb
        VtL9H5h0AP6X46y0670doRl8Wnwv09z+QeSzJaO168PVWw0net0z8Y9LpfbtngCtP2kChPE+OS4u0
        CH5p/fHg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ncmGo-002sZ3-G1; Fri, 08 Apr 2022 10:55:15 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D2ED3300212;
        Fri,  8 Apr 2022 12:55:11 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id AD86E2B552B8F; Fri,  8 Apr 2022 12:55:11 +0200 (CEST)
Date:   Fri, 8 Apr 2022 12:55:11 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/9] arm64: livepatch: Use DWARF Call Frame
 Information for frame pointer validation
Message-ID: <YlAUj6w6fePEo7v+@hirez.programming.kicks-ass.net>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407202518.19780-1-madvenka@linux.microsoft.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Apr 07, 2022 at 03:25:09PM -0500, madvenka@linux.microsoft.com wrote:

> [-- application/octet-stream is unsupported (use 'v' to view this part) --]

Your emails are unreadable :-(
