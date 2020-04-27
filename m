Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F7B1BAA73
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2020 18:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgD0Qwy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 27 Apr 2020 12:52:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53394 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726208AbgD0Qwx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 27 Apr 2020 12:52:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588006372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IeLFSaS8ezTi+2RJ/llDpWcAwPrT3k0KSS3uMh365gw=;
        b=OIccgn8A2bskSU7FSxz/GuH9lmrAglDEfVnFbjRXbTjTcLkHoq92DSDwh0BtRGcrcRLCcF
        lDtlfVApbcoxQ7AKEkWZPhcgnQJA7boI6pjioeiRHEgG8tuxU7qvQvDvOgD1elm7OLBjQo
        ypJ6eWZrQN3j04EubY/fh0oEsV520pU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-Z16BndkVPJ6UJjzV3R1T-g-1; Mon, 27 Apr 2020 12:52:46 -0400
X-MC-Unique: Z16BndkVPJ6UJjzV3R1T-g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF05D872FE0;
        Mon, 27 Apr 2020 16:52:45 +0000 (UTC)
Received: from redhat.com (ovpn-112-171.phx2.redhat.com [10.3.112.171])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 20F015C1D4;
        Mon, 27 Apr 2020 16:52:45 +0000 (UTC)
Date:   Mon, 27 Apr 2020 12:52:43 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>, live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH v3 00/10] livepatch,module: Remove .klp.arch and
 module_disable_ro()
Message-ID: <20200427165243.GA7222@redhat.com>
References: <cover.1587812518.git.jpoimboe@redhat.com>
 <a566f775-4e5b-6ced-079b-4951dfd98cab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a566f775-4e5b-6ced-079b-4951dfd98cab@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Apr 27, 2020 at 08:22:03AM -0400, Joe Lawrence wrote:
> On 4/25/20 7:07 AM, Josh Poimboeuf wrote:
> > v3:
> > - klp: split klp_write_relocations() into object/section specific
> >    functions [joe]
> > - s390: fix plt/got writes [joe]
> > - s390: remove text_mutex usage [mbenes]
> > - x86: do text_poke_sync() before releasing text_mutex [peterz]
> > - split x86 text_mutex changes into separate patch [mbenes]
> > 
> > v2:
> > - add vmlinux.ko check [peterz]
> > - remove 'klp_object' forward declaration [mbenes]
> > - use text_mutex [jeyu]
> > - fix documentation TOC [jeyu]
> > - fix s390 issues [mbenes]
> > - upstream kpatch-build now supports this
> >    (though it's only enabled for Linux >= 5.8)
> > 
> > These patches add simplifications and improvements for some issues Peter
> > found six months ago, as part of his non-writable text code (W^X)
> > cleanups.
> > 
> > Highlights:
> > 
> > - Remove the livepatch arch-specific .klp.arch sections, which were used
> >    to do paravirt patching and alternatives patching for livepatch
> >    replacement code.
> > 
> > - Add support for jump labels in patched code.

Nit: support for the hopefully common cases anyway: jump labels whose
keys are not going to require late-module klp-relocation (defined in an
unloaded module).

> > 
> > - Remove the last module_disable_ro() usage.
> > 
> > For more background, see this thread:
> > 
> >    https://lkml.kernel.org/r/20191021135312.jbbxsuipxldocdjk@treble
> > 
> > This has been tested with kpatch-build integration tests and klp-convert
> > selftests.
> > 
> 
> Hi Josh,
> 
> I've added some late module patching tests for klp-convert as well as
> extended the existing ones.  I'll put them on-top of v3 and give it some
> test runs today (x86, ppc64le, s390x) and report back.

Ok all three arches look good with the klp-convert WIP tests.  For
reference, I pushed the combined branch up to github [1] if anyone else
wants to see the klp-relocations in action first hand.

For the series:
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>


[1] https://github.com/joe-lawrence/linux/tree/jp-v3-klp-convert

-- Joe

