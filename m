Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A684023AF80
	for <lists+live-patching@lfdr.de>; Mon,  3 Aug 2020 23:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbgHCVMn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 Aug 2020 17:12:43 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50940 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729119AbgHCVMn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 Aug 2020 17:12:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596489162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oDk7BkLvturoY2j4bZcgcnngVm0+SqYFOos8ttHdu5Y=;
        b=itBpUuOU55gK2BPG0RagsSlnnm9PIyZJeMxtFoFwR3ftTG7tZ4gww6rZ9UmB2WMccXP8lr
        WrU1HL1kRGxkEYxn0QViv9GH21Cr9coAojBeGQB+aubtVB2KGQNl6Z50+8TOfX54TLCmLu
        8Vvq9Sj2tHBEQiOMeac4mymsBpduxIo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-GjiaqvMBOICm3jt1_nLYPw-1; Mon, 03 Aug 2020 17:12:38 -0400
X-MC-Unique: GjiaqvMBOICm3jt1_nLYPw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 580D8102C7ED;
        Mon,  3 Aug 2020 21:12:36 +0000 (UTC)
Received: from redhat.com (ovpn-112-64.phx2.redhat.com [10.3.112.64])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FFE15D9F7;
        Mon,  3 Aug 2020 21:12:32 +0000 (UTC)
Received: from fche by redhat.com with local (Exim 4.94)
        (envelope-from <fche@redhat.com>)
        id 1k2hky-0008Hd-VD; Mon, 03 Aug 2020 17:12:29 -0400
Date:   Mon, 3 Aug 2020 17:12:28 -0400
From:   "Frank Ch. Eigler" <fche@redhat.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        Miroslav Benes <mbenes@suse.cz>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
        live-patching@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <20200803211228.GC30810@redhat.com>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <e9c4d88b-86db-47e9-4299-3fac45a7e3fd@virtuozzo.com>
 <202008031043.FE182E9@keescook>
 <fc6d2289-af97-5cf8-a4bb-77c2b0b8375c@redhat.com>
 <20200803193837.GB30810@redhat.com>
 <202008031310.4F8DAA20@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202008031310.4F8DAA20@keescook>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi -

On Mon, Aug 03, 2020 at 01:11:27PM -0700, Kees Cook wrote:
> [...]
> > Systemtap needs to know base addresses of loaded text & data sections,
> > in order to perform relocation of probe point PCs and context data
> > addresses.  It uses /sys/module/...., kind of under protest, because
> > there seems to exist no MODULE_EXPORT'd API to get at that information
> > some other way.
> 
> Wouldn't /proc/kallsysms entries cover this? I must be missing
> something...

We have relocated based on sections, not some subset of function
symbols accessible that way, partly because DWARF line- and DIE- based
probes can map to addresses some way away from function symbols, into
function interiors, or cloned/moved bits of optimized code.  It would
take some work to prove that function-symbol based heuristic
arithmetic would have just as much reach.

- FChE

