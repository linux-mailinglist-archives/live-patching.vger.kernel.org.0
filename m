Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD131A8977
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2020 20:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503938AbgDNS1b (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Apr 2020 14:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2503947AbgDNS13 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Apr 2020 14:27:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBD2C061A0C;
        Tue, 14 Apr 2020 11:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=w2oScmLWvNS0pE9g0BNFVGRJ1Z3X4h/XpiGkuoMfTl8=; b=tD3LQn4fu/VaX7Xe/1Od68HJYr
        pQsue+85LW0nQVRKGurdh9H89+cq+T7kyJK81NIT/34ojHpMLUsNro0ArivA2S8eX5d2kbOcq7q3n
        C16cG89tI/IOhvjg0reh1ApEsmxAL/UIaMByTx2VoL/EsNoCBaK97mxF1/ypRYj9w7Y1PyQ6wVU37
        VpOuv24MwH0C0JrSMk8gEFV8glwMK9kySl3I53rr1anvD37m99Shsy0d5k6S2isvE97N62nmkoGi6
        MVUvxqCHAbJFNiaOPw/Rn/nu6wCcOxItpQyELcpbZ0diuG7IhS2qYfX9RpmUfucBzt0OEkpTcZZoT
        JG4Ccq9A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jOQHR-0005cu-1P; Tue, 14 Apr 2020 18:27:29 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 118D1981086; Tue, 14 Apr 2020 20:27:27 +0200 (CEST)
Date:   Tue, 14 Apr 2020 20:27:26 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH 0/7] livepatch,module: Remove .klp.arch and
 module_disable_ro()
Message-ID: <20200414182726.GF2483@worktop.programming.kicks-ass.net>
References: <cover.1586881704.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1586881704.git.jpoimboe@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 14, 2020 at 11:28:36AM -0500, Josh Poimboeuf wrote:
> Better late than never, these patches add simplifications and
> improvements for some issues Peter found six months ago, as part of his
> non-writable text code (W^X) cleanups.

Excellent stuff, thanks!!

I'll go brush up these two patches then:

  https://lkml.kernel.org/r/20191018074634.801435443@infradead.org
  https://lkml.kernel.org/r/20191018074634.858645375@infradead.org

and write a patch that makes the x86 code throw a wobbly on W+X.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
