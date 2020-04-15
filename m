Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8621A8FF1
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2020 02:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733249AbgDOA50 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Apr 2020 20:57:26 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21284 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733230AbgDOA5Y (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Apr 2020 20:57:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586912243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=INu02MFWkvXpu23KW+Iy6RseGgVn0wutAQ1sHDlj8rA=;
        b=Eb5X25fg2qPjpqtyALLvAqdGjBP05473TZLWsVOJf3/MRM/Acyggy82IAug4WUOv8ytFT+
        ASneXL5Ao6JOPqXq4saSb0IRIezcEKyxHC13W3hxhWvO2Hl+MqjVWDquoKB/bGR/KHiDuZ
        AwuY0haM+B+BfK7q6sxOyA6gDK2DpN4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-J6xstRbGMJC1mcBzvi2yPw-1; Tue, 14 Apr 2020 20:57:18 -0400
X-MC-Unique: J6xstRbGMJC1mcBzvi2yPw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8FB58017F5;
        Wed, 15 Apr 2020 00:57:17 +0000 (UTC)
Received: from [10.3.112.171] (ovpn-112-171.phx2.redhat.com [10.3.112.171])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FB8760BE0;
        Wed, 15 Apr 2020 00:57:17 +0000 (UTC)
Subject: Re: [PATCH 0/7] livepatch,module: Remove .klp.arch and
 module_disable_ro()
To:     Josh Poimboeuf <jpoimboe@redhat.com>, live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>
References: <cover.1586881704.git.jpoimboe@redhat.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <187a2ccd-1d04-54db-2fd3-8c4ca6872830@redhat.com>
Date:   Tue, 14 Apr 2020 20:57:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cover.1586881704.git.jpoimboe@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 4/14/20 12:28 PM, Josh Poimboeuf wrote:
> Better late than never, these patches add simplifications and
> improvements for some issues Peter found six months ago, as part of his
> non-writable text code (W^X) cleanups.
> 
> Highlights:
> 
> - Remove the livepatch arch-specific .klp.arch sections, which were used
>    to do paravirt patching and alternatives patching for livepatch
>    replacement code.
> 
> - Add support for jump labels in patched code.

Re: jump labels and late-module patching support...

Is there still an issue of a non-exported static key defined in a 
to-be-patched module referenced and resolved via klp-relocation when the 
livepatch module is loaded first?  (Basically the same case I asked Petr 
about in his split livepatch module PoC. [1])

Or should we declare this an invalid klp-relocation use case and force 
the livepatch author to use static_key_enabled()?

[1] https://lore.kernel.org/lkml/20200407205740.GA17061@redhat.com/

-- Joe

