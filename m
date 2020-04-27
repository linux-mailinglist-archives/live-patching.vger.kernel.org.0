Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946A51BA37F
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2020 14:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgD0MWM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 27 Apr 2020 08:22:12 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22809 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726589AbgD0MWM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 27 Apr 2020 08:22:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587990131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4yrEcbYqeWqSME0VKr0tn8j8NtL6y9pbDQetkAUTq5Q=;
        b=h991u1ChjDASboPez1dHmQEkRGdA/o07zpGWdboeOmPSTzRg4keqJa+RkWvexF1c/qVFPJ
        IyBMEXSLAzZZM6gFk9rD92NWUQhtJb/tFriY3CHThE6/lD1ttEb8XvMRGivRSgmWnzaNmD
        RX9HmQpCMyTlP5/jdWkafnYZTjH5wsM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-ogj_N9Q6PG22mSx3bl-ymg-1; Mon, 27 Apr 2020 08:22:06 -0400
X-MC-Unique: ogj_N9Q6PG22mSx3bl-ymg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26B6F800685;
        Mon, 27 Apr 2020 12:22:05 +0000 (UTC)
Received: from [10.3.112.171] (ovpn-112-171.phx2.redhat.com [10.3.112.171])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D05E27CC9;
        Mon, 27 Apr 2020 12:22:04 +0000 (UTC)
Subject: Re: [PATCH v3 00/10] livepatch,module: Remove .klp.arch and
 module_disable_ro()
To:     Josh Poimboeuf <jpoimboe@redhat.com>, live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>
References: <cover.1587812518.git.jpoimboe@redhat.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <a566f775-4e5b-6ced-079b-4951dfd98cab@redhat.com>
Date:   Mon, 27 Apr 2020 08:22:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cover.1587812518.git.jpoimboe@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 4/25/20 7:07 AM, Josh Poimboeuf wrote:
> v3:
> - klp: split klp_write_relocations() into object/section specific
>    functions [joe]
> - s390: fix plt/got writes [joe]
> - s390: remove text_mutex usage [mbenes]
> - x86: do text_poke_sync() before releasing text_mutex [peterz]
> - split x86 text_mutex changes into separate patch [mbenes]
> 
> v2:
> - add vmlinux.ko check [peterz]
> - remove 'klp_object' forward declaration [mbenes]
> - use text_mutex [jeyu]
> - fix documentation TOC [jeyu]
> - fix s390 issues [mbenes]
> - upstream kpatch-build now supports this
>    (though it's only enabled for Linux >= 5.8)
> 
> These patches add simplifications and improvements for some issues Peter
> found six months ago, as part of his non-writable text code (W^X)
> cleanups.
> 
> Highlights:
> 
> - Remove the livepatch arch-specific .klp.arch sections, which were used
>    to do paravirt patching and alternatives patching for livepatch
>    replacement code.
> 
> - Add support for jump labels in patched code.
> 
> - Remove the last module_disable_ro() usage.
> 
> For more background, see this thread:
> 
>    https://lkml.kernel.org/r/20191021135312.jbbxsuipxldocdjk@treble
> 
> This has been tested with kpatch-build integration tests and klp-convert
> selftests.
> 

Hi Josh,

I've added some late module patching tests for klp-convert as well as 
extended the existing ones.  I'll put them on-top of v3 and give it some 
test runs today (x86, ppc64le, s390x) and report back.

BTW, this may be out of scope for this patchset, but is it a large 
amount of work to support clearing klp-relocations on target module 
unload?  ie, this test case:

   - (target module and livepatch loaded)
   - rmmod target_mod
   - modprobe target_mod       << fails as reloc target is non-zero

IIRC, Miroslav had taken a stab at this last year, but I don't remember 
what the technical problems were then.

-- Joe

