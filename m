Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 878461700EF
	for <lists+live-patching@lfdr.de>; Wed, 26 Feb 2020 15:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgBZOQx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 26 Feb 2020 09:16:53 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24909 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726899AbgBZOQw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 26 Feb 2020 09:16:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582726611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eXnLmd8QHrzsWQo/ag5VQRXEgTXCyqDRSxm2zThuNG0=;
        b=LZCDcKk9M9zbQFIDYf2lBW7sZsRoAR4k1UsqFXTMtzyVqgLnTnPB9qWNVStqaut1dWhQVM
        7wPXQm0hQIaIQA9Irn5GPt7BOrKO+hKkqFjs7Bf19Is3VNpkqB80HkGpra8ufHaNDs6bE4
        RwGxR3wmc8O+D+XXHsN6NNaU5qGnnQs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-2yoQdmw7P5yLIIx_iUKC5Q-1; Wed, 26 Feb 2020 09:16:47 -0500
X-MC-Unique: 2yoQdmw7P5yLIIx_iUKC5Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A316D800D53;
        Wed, 26 Feb 2020 14:16:45 +0000 (UTC)
Received: from [10.16.196.218] (wlan-196-218.bos.redhat.com [10.16.196.218])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 27029101D4AA;
        Wed, 26 Feb 2020 14:16:44 +0000 (UTC)
Subject: Re: [PATCH 0/3] Unexport kallsyms_lookup_name() and
 kallsyms_on_each_symbol()
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Petr Mladek <pmladek@suse.com>, Will Deacon <will@kernel.org>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        akpm@linux-foundation.org,
        "K . Prasad" <prasad@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Quentin Perret <qperret@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        live-patching@vger.kernel.org
References: <20200221114404.14641-1-will@kernel.org>
 <alpine.LSU.2.21.2002251104130.11531@pobox.suse.cz>
 <20200225121125.psvuz6e7coa77vxe@pathway.suse.cz>
 <943e7093-2862-53c6-b7f4-96c7d65789b9@redhat.com>
 <alpine.LSU.2.21.2002251854550.1630@pobox.suse.cz>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <24d2e5c8-6e5e-8f69-c6b2-22e16022d4c5@redhat.com>
Date:   Wed, 26 Feb 2020 09:16:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.2002251854550.1630@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 2/25/20 1:01 PM, Miroslav Benes wrote:
> Anyway, as far as Will's patch set is concerned, there is no real obstacle
> on our side, is there?
> 

It places greater importance on getting the klp-relocation parts 
correct, but assuming is is/will be then I think we're good.

-- Joe

